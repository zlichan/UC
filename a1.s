/*
  This program finds the minimum of the expression:
			y = 2x^3 - 18x^2 + 10x + 39
	in the range -2 <= x <= 11
*/

	.global main					                  !Make main globally visibly
xfmt:	.asciz	"Value of X is: %d \n"			!Print formatter for X
yfmt:	.asciz	"Value of Y is: %d \n"			!Print formatter for Y
mfmt:	.asciz	"Minimum value is: %d \n"		!Print formatter for Minimum 
	.align 4				                       	!Enforce alignment

main:	
	mov	-2, %l1					!Move -2 into register l1 to initiate x

loop:
	/* 	Multiply current x-value with 10, add constant 39 
		Return to register %l2 */
	mov	39, %l2					!Move 39 the register l2
	mov 	%l1, %o0				!Move x-value to register o0
	mov 	10, %o1					!Move 10 to the register o1
	call 	.mul					!Returns 10x 
	nop						!Store 10x in register o0
	add	%o0, %l2, %l2				!Add 10x to %l2 (10x + 39)

	/*	Square the current x-value
		Return to register %l3 */
	mov 	%l1, %o0				!Move x-value to register o0 
	mov 	%l1, %o1				!Move x-value to register o1
	call 	.mul					!Returns x^2
	nop						!Store result in register o0
	mov 	%o0, %l3				!Move x^2 to register l3 (for x^3 calculation)

	/*	Multiply x^2 with -18, add 10x + 39
		Return to register %l2 */
	mov 	-18, %o1				!Move -18 to register o1
	call 	.mul					!Returns -18x^2
	nop						!Store -18x^2 in l3
	add 	%o0, %l2, %l2				!Add -18x^2 to register l2 (-18x^2 + 10x + 39)

	/*	Cube the current x-value
		Return to register %o0 */
	mov 	%l3, %o0				!Move x^2 value to register o0
	mov 	%l1, %o1				!Move x-value to register o1
	call 	.mul 					!Returns x^3
	nop						!Store x^3 to register o0

	/* 	Multiply x^3 with 2, add -18x^2 + 10x + 39 */
	mov 	2, %o1					!Move 2 to register o1
	call 	.mul 					!Return 2x^3
	nop						!Store 2x^3 to register o0
	add 	%o0, %l2, %l2				!Add 2x^3 to register l2 (2x^3 - 18x^2 + 10x + 39)

	mov 	-2, %o0					!Move -2 to register o0
	cmp	%o0, %l1 				!Check for first iteration (if x = -2)
	bne	cont 					!Branch to cont if x != -2
	nop						!Delay slot
	mov 	%l2, %l0 				!Move y-value to register l0

cont: 
	/*	Compare current y-value (%l2) to current min-value (%l0)
		%l2 > %l0: Branch to nochange
		%12 > %l0: %l0 = %l2 */
	cmp 	%l2, %l0 				!Compare current y-value to register l0 (current min-value)
	bge	nochange 				!Branch to nochange if current y-value is greater than current min-value
	nop						!Delay slot
	mov 	%l2, %l0				!Replace current min-value with current y-value

nochange:
	/*	Print current values to screen
		Increment x by 1 */
	set 	xfmt, %o0				!Initiate xfmt
	mov 	%l1, %o1				!Move current x-value to register o1
	call 	printf					!Print x-value
	nop						!Delay slot

	set 	yfmt, %o0				!Initiate yfmt
	mov 	%l2, %o1				!Move current y-value to register o1
	call 	printf					!Print y-value
	nop						!Delay slot

	set 	mfmt, %o0				!Initiate mfmt
	mov 	%l0, %o1				!Move current min-value to register o1
	call 	printf					!Print min-value
	nop						!Delay slot
	inc 	%l1					!Increment current x-value by 1

last: 
	/* 	Compare current x-value to 11
		x < 11: Branch to loop
		x >= 11: Fall through */
	cmp 	%l1, 11					!Compare current x-value to 11
	ble	loop 					!if x < 11, branch to loop
	nop						!Delay slot
