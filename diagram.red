Red []
;diagram: 
context [
	lbks:  make block! 50  ;stack of layout blocks
	gbks:  make block! 50  ;stack of group blockss
	ebks:  make block! 10  ;stack of elements ; is it needed?
	fbks:  make block! 30  ;stack of blocks of firsts elements of groups in layout
	hbks:  make block! 30  ;stack of blocks of last elements of groups in layout
	rbks:  make block! 30  ;stack of reference blocks for layouts
	lopts: make block! 50  ;stack of layout options
	gopts: make block! 50  ;stack of group options
	eopts: make block! 50  ;stack of element ooptions
	bk:        ;changeable
	lbk:       ;layout block - defaults for following gbk-s, i.e. groups of elements
	gbk:       ;group block; block of elements (row, col or round) - determines defaults for following (contained?) elements
	             ;styling (colors, lines, font(?)), shapes, positioning model (how to advance `pos`, translate or rotate...)
	ebk:       ;element block, holding styling, shaping, font, label properties
	fbk:       ;last group of firsts (fbks)
	hsz:       ;half size of element
	sub:       ;subblock of an element
	lsz:       ;record dynamically maximal size of the diagram
	esz:       ;element size
	gsz:       ;keep track of group size
	tsz:       ;current text size
	ssz:       ;sublayout's size
	lpos:      ;layout's position
	gpos:      ;group's position
	epos:      ;element's position
	tpos:      ;text's position
	spos:      ;sublayout's position
	gofs:      ;group's offset from initial (bc of element's protusion)
	lofs:      ;layout's offset from initial (bc of group's protusion)
	lo:        ;intermediate lofs, used to position connectors
	sofs:      ;sublayout's offset
	
	shape: none ;default shape if none is provided
	shape-opts:  make block! 10
	style-opts:  make block! 10
	font-opts:   make block! 10
	text-opts:   make block! 10
	
	;individual connector options
	cshape: none ;default connector if none is provided
	cshape-opts: make block! 10
	cstyle-opts: make block! 10
	cfont-opts:  make block! 10
	ctext-opts:  make block! 10
	
	p: 		;
	s:      ;keep track in parse rules
	a:      ;
	e:      ;
	c:      ;
	f:      ;font-options 
	main:   ;dimension to increment on advancement of shapes
	anti:   ;dimension perpendicular to main advancement of shapes
	gmain:  ;dimension to increment groups
	ganti:  ;perpendicular direction to advancement of groups
	
	origin:       ;absolute coordinates where to continue (set `pos`)
	at*:          ;absolute position of next group or element
	pad*:         ;relative position from current of next group or element
	gap*:
	space:        ;default space between shapes
	grid-space:   ;default number of cells between elements in grid
	pos:          ;dynamically set current position for shapes
	grid*: grid:  ;size of cells to place shapes into
	cell: 	      ;intermediate element size
	sz:           ;used for calculation of element's position
	lgpos:        ;last group's final position
	lgsz:         ;last group's total size
	last-pos:     ;canonical position of last element
	last-epos:    ;actual position of last element
	last-size:    ;actual size of last element
	last-type:
	last-class:
	last-dir:
	lst-pos:      ;intermediates
	lst-epos:     ;-----"------
	lst-size:     ;-----"------
	group-last-pos:  ;For last element of a group
	group-last-epos: ;to be able to connect 
	group-last-size: ;to next group
	lgdir:        ;direction of last auto-group (return (anti) or next (main))
	lgfix?:       ;was last roup fixed?
	class:        ;supertype (proper draw shape)
	type:         ;type of shape
	ctype:        ;type of connector
	size:         ;shape's default size
	ref-size:     ;reference size, can change for rows and cols to ensure proper alignment
	points:       ;block of pairs or integers for some polygon shapes
	fixed:        ;shape's size (opt [width | height]) if side = 'inside
	growing:      ;shape's size (opt [width | height]) if side = 'outside
	tight:        ;shape's size tight around label (with padding)
	step:         ;default step in tilted shapes
	clr:          ;color
	
	label-text:   ;text for current shape's label
	text-padding: ;padding for labels (by default general padding is applied)
	adjust:       ;adjust text position by relative amount
	padding:      ;text and subblock padding (inside from border)
	padd:
	margin:       ;margin around shape to keep label away if outside
	gdir:         ;direction of groups
	dir:          ;direction to proceed with layout
	next-dir:     ;initial direction inside next group
	old-dir:      ;previous direction before change
	ghalign:      ;groups horizontal alignment
	gvalign:      ;groups vertical alignmenmt
	galign:       ;current group alignment
	halign:       ;shape's horizontal alignment
	valign:       ;shape's vertical alignment
	align:        ;current halign or valign
	talign:       ;text's alignment
	side:         ;text's positioning inside or outside shape
	move?:        ;move position if group is not empty
	first?:       ;element is first in group (2) or in sublayout (1)
	firsts:       ;pos and size of first elements of all groups in (sub)layout
	lasts:        ;pos and size of last elements of all groups in (sub)layout
	connected?:   ;are elements in groups connected?
	connect?:     ;connect individual elements
	split*:       ;count level of splitted group
	split?:       ;switch for splitting group
	join?:        ;joining element after split
	tmp-space:    ;remember space while inserting connectors 

	previous:     ;reference to previous element in group
	stretch?:     ;switch for stretching elements to same width/length
	stretched?:   ;general switch for stretching
	
	center:       ;Center of roundy layout
	radius:       ;Radius of roundy layout
	;start-angle:  ;Angle for first element in roundy layouts
	start:        ;Start of next shape in roundy layout
	start*:       ;Start of current shape in roundy layout
	sweep:        ;Default angle of arcy shape in roundy layout
	sweep*:       ;Angle of current arcy shape
	last-sweep:   ;Angle of last arcy shape 
	angle:
	
	arrow:        ;arrows off or arrow-shape
	arrow-shape:  ;default shape of arrows
	arrow-size:   ;default size of arrow-heads
	arrow-angle:  ;angle for pointing arrows

	fix?:         ;fix group's initial position (don't add gofs)? For single group
	ref:          ;reference to shape
	
	from-dir:     ;from which side of shape (for connector)
	to-dir:       ;to which side of shape (for connector)
	from*:        ;from which shape (reference)
	to*:          ;to which shape (reference)
	   none
	  
	
	default-font: make font! [size: 12] ;to be used if no different font-settings are set
	
	refs:         make block! 20    ;stack of references
	references:   make map! copy [] ;map of references to shapes
	rfs:          make map! copy [] ;intermediate
	ref-marks:    make block! 20    ;stack of ref-marks
	cpath:    make block! 10    ;to optionally mark path of the connector
	
	init: does [
		bk: lbk:  make block! 30
		gbk:      make block! 30
		fbk: fbks
		
		append lbk [fill-pen white font default-font]
		
		lsz:  lpos: lofs: lo: 0x0
		gsz:  gpos: gofs: 0x0
		esz:  epos: pos:  0x0
		tpos: 0x0
		init-last
		cell: p: s: e: c: f: none
		clr: white
		
		gdir:    'across
		galign:  gvalign: 'top
		ghalign: 'left
		
		dir:     'to-right
		align:   valign: 'middle   ;align: none "Intermediate for shape's alignment"
		halign:  'center
		next-dir: dir
		old-dir:  dir
		main:    'x
		anti:    'y
		gmain:   'x
		ganti:   'y
		side:    'inside
		talign:  none
	
		type: shape: 'box
		size:    130x80
		ref-size: size
		grid*: grid: none
		fixed:   false
		growing: false
		tight:   false
		
		origin:  20x20
		space:   50x50
		grid-space: 0x0
		step:    10
		
		padding: 10x10
		padd:    0x0
		margin:  10x10
		text-padding: none
		adjust:  0x0
		
		ctype: cshape: 'ortho;'line
		connected?: no
		connect?:  no;yes;
		split*:    0
		split?:    false
		join?:     false
		tmp-space: space
		move?:     no
		first?:    1;no;yes;
		lst-pos: lst-epos: lst-size: none
		group-last-pos: group-last-epos: group-last-size: none
		lgdir: 'return 
		lgfix?: none
		lgpos: lgsz: 0x0
		
		stretched?: false
		stretch?    false
		
		start: start*: -90
		center:      100x100
		radius:      100x100
		sweep:       45
		last-sweep:  0
		angle:       0
		
		arrow:       false;true;
		arrow-shape: 'charon;'triangle;'cross;'circle;
		arrow-size:  8x8
		arrow-angle: 0
		
		compact?: no;yes;
		fix?:     yes
		
		ref:      none
		clear rbks
		clear rfs
		clear refs
		clear references
		clear ref-marks
	] 
	
	dummy: make-face/size 'text 300x50
	dummy/font: default-font
	center-para: make para! [align: 'center wrap?: true] ;? unused?
	right-para:  make para! [align: 'right wrap?:  true]
	left-para:   make para! [align: 'left wrap?:   true]
	dummy/para: right-para;center
	;rt-dummy: rtd-layout [font 12 "" /font]
	
	text-size: does [
		either label-text [
			dummy/text: label-text
			size-text dummy
		][0x0]
	]
	
	resolve-font: function [fnt [word! path!]][
		font: attempt [get fnt]
		font: switch/default type?/word font [
			object!     [fnt]
			block!      [make font! font]
			integer!    [make font! compose [size: (font)]]
			string!     [make font! compose [name: (font)]]
			tuple!      [make font! compose [color: (font)]]
			word! path! [resolve-font font]
		][cause-error 'user 'message rejoin ["Font not defined: " font]]
		font
	]
	
	init-lbk: func [
		"Initialize new sublayout"
	][
		bk: lbk:     make block! 30
		gbk:         make block! 30
		
		shape-opts:  make block! 10
		style-opts:  make block! 10
		font-opts:   make block! 10
		text-opts:   make block! 10

		cshape-opts: make block! 10
		cstyle-opts: make block! 10
		cfont-opts:  make block! 10
		ctext-opts:  make block! 10
		  
		lsz:   gsz:  esz:  pos:  0x0
		lpos:  gpos: epos: tpos: 0x0
		origin: none
		lofs:  gofs:  0x0
		init-last
		append/only fbks fbk: copy []
		append/only hbks hbk: copy []
		first?: 1
		fix?: no
		move?: connect?: no
	]
	
	init-group: func [
		"Initialize group vars"
	][
		esz: gsz: gofs: 0x0
	    epos: pos: 0x0
	]
	
	init-shape: does [
	    clear style-opts 
		clear shape-opts 
		clear font-opts 
		clear text-opts
		points: none
	]

	init-cshape: does [
	    clear cstyle-opts 
		clear cshape-opts 
		clear cfont-opts 
		clear ctext-opts
		;points: none
	]
	
	init-last: does [last-pos: last-epos: last-size: 0x0 last-type: last-dir: none]
	
	init-from-to: func [
		"Initialize connector ends"
	][
		from*: to*: from-dir: to-dir: none
		clear cpath
	]
	
	add-shape: func [
		"Start configuring shape"
		/arr ;conn
		/local 
			_fnt_  "Default-font"
			size*  "Element's size without label or points"
			tsz    "Label's proper size"
			tsz*   "Label's size with padding"
			
			fixed*
			growing*
			side*
			padding*
			margin*
			tight*
			adjust*
			def
			r cx cy
	][
		tsz*: 0x0
		ebk: make block! 20
		esz: size*: either arr [arrow-size][any [shape-opts/size        size]]
		halign*:    any [shape-opts/halign      halign]
		valign*:    any [shape-opts/valign      valign]
		fixed*:     any [shape-opts/fixed       fixed]
		  if none? fixed* [fixed*: false]
		growing*:   any [shape-opts/growing     growing]
		  if none? growing* [growing*: false]
		tight*:     any [shape-opts/tight       tight]
		  if none? tight* [tight*: false]
		grid*:      any [all [not empty? eopts select pick last eopts 2 'grid] grid]
		step*:      any [shape-opts/step        step]
		switch type?/word step* [
			integer!         [step*: to-pair step*]
			float! percent!  [step*: size* * step*]
		]
		side*:      any [text-opts/side         side]
		padding*:   any [text-opts/padding text-padding shape-opts/padding  padding]
		if integer? padding* [padding*: to-pair padding*]
		margin*:    any [shape-opts/margin      margin]
		if integer? margin*  [margin*:  to-pair margin*]
		adjust*:    any [text-opts/adjust       adjust]
		type*:      either arr [arrow-shape][type]
		if all [not label-text ref][label-text: to-string ref]
		
		;STYLING
		;Element's styling options should be before shape options
		switch type* [
			blank text [append ebk [fill-pen off pen off]]
			guide [esz: size*: 0x0 append ebk [fill-pen off pen off]]
			corner charon spline line [append ebk [fill-pen off]]
			bar [if shape-opts/int [size*/:anti: esz/:anti: shape-opts/int]]
		]
		append ebk style-opts
		
		;Adjust font if needed
		if all [label-text not empty? font-opts][
			;Record current font
			;default-font: dummy/font
			switch/default font-opts/1 [
				font [
					_fnt_: resolve-font font-opts/2
					repend ebk ['font _fnt_]
				]
				spec [repend ebk ['font _fnt_: make font! font-opts/2]]
			][
				repend ebk ['font _fnt_: make font! font-opts];dummy/font
			]
			dummy/font: _fnt_
		]
		
		;SHAPE
		;Add shape type
		if class: switch type* [
			box 
			square 
			roundbox
			bar
			blank
			guide
			text          ['box     ]
			
			triangle      ['triangle]
			
			diamond 
			pentagon 
			hexagon 
			octagon
			polygon 
			trapez 
			rhomb
			parallelogram
			kite
			dart
			star          ['polygon ]
			
			ellipse 
			circle        ['ellipse ]
			
			corner
			line
			hline
			vline
			ortho         ['line    ]  ;orthogonal lines
			
			spline        ['spline  ]
			sline         ['shape   ]  ;snake-line
			
			sector
			arc           ['arc     ]  ;open arc
			curve         ['curve   ]
			
			sector        ['arc     ]  ;closed arc
			
			halfround
			trefoil
			quatrefoil
			cross                      ;two lines x
			plus                       ;two lines +
			o-cross                    ;two lines x in circle
			o-plus                     ;two lines + in circle
			cross-box
			plus-box
			charon        ['shape   ]  ;open arrowhead
			
		][append ebk class] 
		
		;DIMENSIONS
		;Explicit size
		;If element is given series of points, calculate its size
		if all [
			not false = fixed*        ;need to check logic, can be word too
			block? size*
		][
			esz: points/1
			foreach point next points [esz: max esz point]
			case [
				any ['width  = fixed*][esz/x: size*/x]
				any ['height = fixed*][esz/y: size*/y]
			]
			size*: esz
		]
		
		;Determine label's size
		if 0x0 <> tsz: text-size [
			tsz*: either side* = 'outside [tsz][2 * (padding*) + tsz]
		]
		htsz: tsz / 2
		
		;Is size depending on label's size?
		either either side* = 'outside [
			true = growing*   ;label is outside and shape size is growing
		][
			false = fixed*      ;label is inside and shape size is not fixed
		][
			esz: either tight* [tsz*][max size* tsz*]
		][
			
			if either side* = 'outside ['width = growing*]['width <> fixed*][
				esz/x: either tight* = 'width [tsz*/x][max size*/x tsz*/x]
			]
			if either side* = 'outside ['height = growing*]['height <> fixed*][
				esz/y: either tight* = 'height [tsz*/y][max size*/y tsz*/y]
			]
		]
		
		;Element's half-size
		hsz: esz / 2

		;Shape's alignment
		either find [to-right to-left] dir [ ;? Should it be set when changing direction?
			align:      valign*
			anti-align: halign*
		][
			align:      halign*
			anti-align: valign*		
		]
		anti: pick [x y] main = 'y ;??Redundant??
		
		if dir = 'cw [
			
		]
		
		;Shape's definition
		;def: #include %shape-definitions.red
		;comment {
		def:
			switch type* [
				box ellipse bar   [[0x0 esz]] ;1x1
				roundbox      [[0x0 esz (to-integer min esz/x esz/y) / 2]] ;Add rounded corner ;1x1
				square 
				circle        [
					esz: to-pair max any [ ;1x1
						shape-opts/int 
						case [
							all [block? sub not empty? sub][max max size*/x size*/y size*/:anti]
							'else [size*/:anti]
						]
					] max tsz*/x tsz*/y 
					hsz: esz / 2
					[0x0 esz]
				]
				hline         [
					switch/default shape-opts/point [
						top    N [[0x0 as-pair esz/x 0]]
						bottom S [[as-pair 0 esz/y esz]]
						middle   [[as-pair 0 hsz/y as-pair esz/x hsz/y]]
					][
						[as-pair 0 hsz/y as-pair esz/x hsz/y]
					]
				]
				vline         [
					switch/default shape-opts/point [
						right  E [[as-pair esz/x 0 esz]]
						left   W [[0x0 as-pair 0 esz/y]]
						center   [[as-pair hsz/x 0 as-pair hsz/x esz/y]]
					][
						[as-pair hsz/x 0 as-pair hsz/x esz/y]
					]
				]
				polygon
				spline
				line          [
					case [
						points [points]
						path? point: shape-opts/point [
							collect [
								foreach point shape-opts/point [
									keep switch point [
										N [as-pair hsz/x 0]
										E [as-pair esz/x hsz/y]
										S [as-pair hsz/x esz/y]
										W [as-pair 0 hsz/y]
										C [hsz]
										NE [as-pair esz/x 0]
										SE [esz]
										SW [as-pair 0 esz/y]
										NW [0x0]
									]
								]
							] 
						]
						word? shape-opts/point [
							switch/default shape-opts/point [
								 N [[0x0 as-pair esz/x 0]]
								'N [[as-pair esz/x 0 0x0]]
								 E [[as-pair esz/x 0 esz]]
								'E [[esz as-pair esz/x 0]]
								 S [[as-pair 0 esz/y esz]]
								'S [[esz as-pair 0 esz/y]]
								 W [[0x0 as-pair 0 esz/y]]
								'W [[as-pair 0 esz/y 0x0]]
								 C [[as-pair hsz/x 0 as-pair hsz/x esz/y]]
								'C [[as-pair hsz/x esz/y as-pair hsz/x 0]]
								 M [[as-pair 0 hsz/y as-pair esz/x hsz/y]]
								'M [[as-pair esz/x hsz/y as-pair 0 hsz/y]]
								NE [[as-pair esz/x 0 as-pair 0 esz/y]]
								SE [[esz 0x0]]
								SW [[as-pair 0 esz/y as-pair esz/x 0]]
								NW [[0x0 esz]]
							][[
								0x0 as-pair 0 esz/y
							]]
						]
						'else [
							either main = 'x [
								[as-pair 0 hsz/y as-pair esz/x hsz/y]
							][
								[as-pair hsz/x 0 as-pair hsz/x esz/y]
							]
						]
					]
				]
				corner [
					switch/default shape-opts/point [
						N [[as-pair 0 esz/y 0x0 as-pair esz/x 0 esz]]
						E [[0x0 as-pair esz/x 0 esz as-pair 0 esz/y]]
						S [[as-pair esz/x 0 esz as-pair 0 esz/y 0x0]]
						W [[as-pair esz/x 0 0x0 as-pair 0 esz/y esz]]
						NE [[0x0 as-pair esz/x 0 esz]]
						SE [[as-pair esz/x 0 esz as-pair 0 esz/y]]
						SW [[0x0 as-pair 0 esz/y esz]]
						NW [[as-pair 0 esz/y 0x0 as-pair esz/x 0]]
					][[
					
					]]
				]
				arc [;Point refers to center of arc
					switch/default shape-opts/point [
						N [[
							as-pair esz/x / 2 0
							as-pair esz/x / 2 esz/y
							0 180
						]]
						E [[
							as-pair esz/x esz/y / 2
							as-pair esz/x esz/y / 2
							90 180
						]]
						S [[
							as-pair esz/x / 2 esz/y
							as-pair esz/x / 2 esz/y
							180 180
						]]
						W [[
							as-pair 0 esz/y / 2
							as-pair esz/x esz/y / 2
							-90 180
						]]
						NE [[
							as-pair esz/x 0
							esz
							90 90
						]]
						SE [[
							esz esz
							180 90
						]]
						SW [[
							as-pair 0 esz/y
							esz
							-90 90
						]]
						NW [[
							0x0	esz
							0 90
						]]
					][
						
					]
				]
				sector [
					sweep*: any [shape-opts/int sweep]
					[center radius start: start + last-sweep sweep* 'closed]
				]
				diamond rhomb [[
					hsz - as-pair 0 hsz/y
					hsz + as-pair hsz/x 0
					hsz + as-pair 0 hsz/y
					hsz - as-pair hsz/x 0
				]]
				trapez        [
					switch/default shape-opts/point [
						N [[
							as-pair step*/x 0
							as-pair esz/x - step*/x 0
							esz
							as-pair 0 esz/y
						]]
						E [[
							0x0
							as-pair esz/x step*/y
							as-pair esz/x esz/y - step*/y
							as-pair 0 esz/y
						]]
						S [[
							0x0
							as-pair esz/x 0
							as-pair esz/x - step*/x esz/y
							as-pair step*/x esz/y
						]]
						W [[
							as-pair 0 step*/y
							as-pair esz/x 0
							esz
							as-pair 0 esz/y - step*/y
						]]
					][[
						as-pair step*/x 1
						as-pair esz/x - step*/x 1
						esz
						as-pair 1 esz/y
					]]
				]
				parallelogram [
					switch/default shape-opts/point [
						E [[
							as-pair step*/x 1
							as-pair esz/x 1
							as-pair esz/x - step*/x esz/y
							as-pair 1 esz/y
						]]
						W [[
							0x0
							as-pair esz/x - step*/x 0
							esz
							as-pair step*/x esz/y
						]]
					][[
						as-pair step*/x 1
						as-pair esz/x 1
						as-pair esz/x - step*/x esz/y
						as-pair 1 esz/y
					]]
				]
				triangle      [
					switch/default shape-opts/point [
						N [[
							as-pair hsz/x 0
							esz
							as-pair 0 esz/y
						]]
						E [[
							0x0 
							as-pair esz/x hsz/y 
							as-pair 0 esz/y
						]]
						S [[
							0x0 
							as-pair esz/x 0
							as-pair hsz/x esz/y
						]]
						W [[
							as-pair 0 hsz/y 
							as-pair esz/x 0
							esz
						]]
						NE [[0x0 as-pair esz/x 0 esz]]
						SE [[as-pair esz/x 0 esz as-pair 0 esz/y]]
						SW [[0x0 esz as-pair 0 esz/y]]
						NW [[0x0 as-pair esz/x 0 as-pair 0 esz/y]]
					][[
						0x0 
						as-pair esz/x hsz/y 
						as-pair 0 esz/y
					]]
				]
				pentagon      [
					switch/default shape-opts/point [
						E [[
							0x0 
							as-pair esz/x - step*/x 1
							as-pair esz/x hsz/y
							as-pair esz/x - step*/x esz/y
							as-pair 1 esz/y
						]]
						S [[
							0x0 
							as-pair esz/x 0
							as-pair esz/x esz/y - step*/y
							as-pair hsz/x esz/y
							as-pair 0 esz/y - step*/y
						]]
						W [[
							as-pair step*/x 0
							as-pair esz/x 0
							esz
							as-pair step*/x esz/y
							as-pair 0 hsz/y
						]]
						N [[
							as-pair hsz/x 0
							as-pair esz/x step*/y
							esz
							as-pair 0 esz/y
							as-pair 0 step*/y
						]]
						NE [[
							0x0
							as-pair esz/x 0
							esz
							as-pair step*/x esz/y
							as-pair 0 esz/y - step*/y
						]]
						SE [[
							as-pair step*/x 0
							as-pair esz/x 0
							esz
							as-pair 0 esz/y
							as-pair 0 step*/y
						]]
						SW [[
							0x0 
							as-pair esz/x - step*/x 0
							as-pair esz/x step*/y
							esz
							as-pair 0 esz/y
						]]
						NW [[
							0x0
							as-pair esz/x 0
							as-pair esz/x esz/y - step*/y
							as-pair esz/x - step*/x esz/y
							as-pair 0 esz/y
						]]
					][[
						0x0 
						as-pair esz/x - step*/x 1
						as-pair esz/x hsz/y
						as-pair esz/x - step*/x esz/y
						as-pair 1 esz/y
					]]
				]
				hexagon       [
					switch/default shape-opts/point [
						E W [[
							as-pair step*/x 0
							as-pair esz/x - step*/x 0
							as-pair esz/x hsz/y
							as-pair esz/x - step*/x esz/y
							as-pair step*/x esz/y
							as-pair 0 hsz/y
						]]
						N S [[
							as-pair hsz/x 0
							as-pair esz/x step*/y
							as-pair esz/x esz/y - step*/y
							as-pair hsz/x esz/y
							as-pair 0 esz/y - step*/y
							as-pair 0 step*/y
						]]
					][[
						as-pair step*/x 0
						as-pair esz/x - step*/x 0
						as-pair esz/x hsz/y
						as-pair esz/x - step*/x esz/y
						as-pair step*/x esz/y
						as-pair 0 hsz/y
					]]
				]
				octagon       [[
					step*
					as-pair hsz/x 0
					as-pair esz/x - step*/x step*/y
					as-pair esz/x hsz/y
					esz - step*
					as-pair hsz/x esz/y
					as-pair step*/x esz/y - step*/y
					as-pair 0 hsz/y
				]]
				halfround     [
					r: round/to (min esz/x esz/y) / 2 1
					cx: max 0 esz/x - r
					cy: max 0 esz/y - r
					switch/default shape-opts/point [
						E [[
							'hline cx
							'arc as-pair esz/x r r r 0 'sweep
							'vline cy
							'arc as-pair cx esz/y r r 0 'sweep
							'hline 0
							'close
						]]
						W [[
							'move as-pair esz/x 0
							'vline esz/y 
							'hline r
							'arc as-pair 0 cy r r 0 'sweep 
							'vline r
							'arc as-pair r 0 r r 0 'sweep 
							'close
						]]
						N [[
							'move as-pair 0 r
							'arc as-pair r 0 r r 0 'sweep
							'hline cx
							'arc as-pair esz/x r r r 0 'sweep
							'vline esz/y
							'hline 0
							'close
						]]
						S [[
							'hline esz/x
							'vline cy
							'arc as-pair cx esz/y r r 0 'sweep
							'hline r
							'arc as-pair 0 cy r r 0 'sweep
							'close
						]]
					][[
							'hline cx
							'arc as-pair esz/x r r r 0 'sweep
							'vline cy
							'arc as-pair cx esz/y r r 0 'sweep
							'hline 0
							'close
					]]
				]
				plus          [[
					'move as-pair 0 hsz/y 
					'line as-pair esz/x hsz/y 
					'move as-pair hsz/x 0 
					'line as-pair hsz/x esz/y
				]]
				cross         [[
					'line esz 
					'move as-pair 0 esz/y 
					'line as-pair esz/x 0 
				]]
				charon        [[
					'line as-pair esz/x hsz/y 
					'line as-pair 0 esz/y 
					;'fill-pen 'off
				]]
				kite          [[
					as-pair 0 hsz/y
					as-pair esz/x - step*/x 0
					as-pair esz/x hsz/y
					as-pair esz/x - step*/x esz/y
				]]
				dart          [[
					0x0
					as-pair esz/x hsz/y
					as-pair 0 esz/y
					as-pair step*/x hsz/y
				]]
				star          [
					points: any [shape-opts/int 5]
					start*:  any [all [shape-opts/data shape-opts/data/start] start]
					angle: 360 / points / 2
					center: to-pair radius: max hsz/:anti max tsz*/x tsz*/y
					outer: center/x;radius
					;probe reduce ["step*:" step* "size*:" size* "tsz*:" tsz* "tpos:" tpos]
					inner: step*/:anti / 2
					;probe reduce ["points:" points "start*:" start* "angle:"  angle "center:" center "outer:"  outer "inner:" inner]
					points:	collect [
						loop points [
							keep center + as-pair outer * cosine start* outer * sine start*
							start*: start* + angle 
							keep center + as-pair inner * cosine start* inner * sine start*
							start*: start* + angle 
						]
					]
					mx: mn: points/1
					foreach i points [
						mx: max mx i 
						mn: min mn i
					]
					esz: mx - mn
					hsz: esz / 2
					if mn <> 0x0 [forall points [points/1: points/1 - mn]]
					;probe reduce ["mn:" mn "mx:" mx "pos:" pos "epos:" epos "esz:" esz]
					points
				]
				stick-man     [[
					'circle as-pair hsz/x step step              ;head
					'line as-pair hsz/x 2 * step 
						  as-pair hsz/x hsz/y + step             ;body
					'line as-pair hsz/x - (2 * step) 3 * step 
						  as-pair hsz/x + (2 * step) 3 * step    ;hands
					'line as-pair hsz/x hsz/y + step 
						  as-pair hsz/x - step esz/y             ;left leg
					'line as-pair hsz/x hsz/y + step 
						  as-pair hsz/x + step esz/y             ;right leg
				]]
				blank         [
					;esz: ref-size 
					esz/:main: 0 
					[0x0 esz]
				]
				text          [[0x0 esz]]
				guide         [[0x0 0x0]]
			]
		;}
		;Add shape's definition to element-block
		either class = 'shape [repend/only ebk def][repend ebk def]
		
		;Add additional data
		if shape-opts/int [
			switch type* [
				box [append ebk shape-opts/int]
			]
		]
		
		;Add label and restore default font if needed
		if label-text [
			;Determine label's position
			tpos: adjust* + switch/default side* [
				outside [
					switch/default any [text-opts/align talign] [
						top-left     [as-pair 0 0 - margin*/y - tsz/y]
						left-top     [as-pair 0 - tsz/x - margin*/x 0]
						top-right    [as-pair esz/x - tsz/x 0 - margin*/y - tsz/y]
						right-top    [as-pair esz/x + margin*/x 0]
						bottom-left  [(as-pair 0 esz/y) + as-pair 0 margin*/y]
						left-bottom  [as-pair 0 - tsz/x - margin*/x esz/y - tsz/y]
						bottom-right [esz - as-pair tsz/x negate margin*/y]
						right-bottom [esz + as-pair margin*/x negate tsz/y]
						left		 [as-pair 0 - tsz/x - margin*/x hsz/y - htsz/y]
						right  		 [as-pair esz/x + margin*/x hsz/y - htsz/y]
						top			 [as-pair hsz/x - htsz/x negate margin*/y + tsz/y]
						bottom 		 [as-pair hsz/x - htsz/x esz/y + margin*/y]
					][
						as-pair hsz/x - htsz/x negate margin*/y + tsz/y  ;top
					]
				]
				inside  [
					switch/default any [text-opts/align talign] [
						top-left 
						left-top     [padding*]
						top-right 
						right-top    [padding* as-pair esz/x - tsz/x - padding*/x padding*/y]
						bottom-left 
						left-bottom  [as-pair padding*/x esz/y - padding*/y - tsz/y]
						bottom-right 
						right-bottom [esz - as-pair tsz/x + padding*/x tsz/y + padding*/y]
						left		 [as-pair padding*/x hsz/y - htsz/y]
						right  		 [as-pair esz/x - padding*/x - tsz/x hsz/y - htsz/y]
						top			 [as-pair hsz/x - htsz/x padding*/y]
						bottom 		 [as-pair hsz/x - htsz/x esz/y - padding*/y - tsz/y]
					][  ;print ["hsz: " hsz "htsz:" htsz]
						hsz - htsz ;center-middle
					]
				]
			][
				hsz - htsz ; center-middle
			]
			
			;Add label
			either text-opts/shape [
				;probe reduce ["label:" label-text "text-opts:" text-opts]
				repend ebk [text-opts/shape tpos tsz 'text tpos label-text]
			][
				repend ebk ['text tpos label-text]
			]
			
			;Restore default font
			if not empty? font-opts [
				append ebk [font default-font]
				dummy/font: default-font
			]
		]
		
		if not arr [add-element]
	]
	
	add-element: func [
		"Calculate shape's position and add shape to group"
		/local tmp-sz
	][
		;probe reduce ["ELEMENT:" label-text "fix?:" fix?] 
		;probe reduce ["START ADD-ELEMENT:" "lep:" last-epos "ls:" last-size]
		;prin "FBKS: " probe fbks
		;prin "HBKS: " probe hbks
		
		;SHAPE's POSITION
		;Initial default position
		;print "INITIAL POS: " 
		;probe 
		epos: initial-position
		
		if first? [ref-size: esz]
		
		;ALIGN SHAPE
		;sz refers to end-point of element's size-box; used for alignment
		if not any [at* pad* gdir = 'radial][
			sz: either grid* [
				;either at* [
				;	epos + grid* 
				;][
					pos + grid*
				;]
			][
				epos + ref-size
			]
			
			;Referential (canonical/default) size
			cell: any [grid* ref-size]
			;probe reduce [label-text "align:" align "main:" main "anti:" anti]
			
			;Adjust position due to alignment
			;probe reduce ["PRE-ALIGN:" "lsz:" lsz "gpos:" gpos "gofs:" gofs "epos:" epos "pos:" pos "esz:" esz "sz:" sz "cell:" cell "ref-size:" ref-size "dir:" dir "align:" align]
			align-shape
			;probe reduce ["POST-ALIGN:" "lsz:" lsz "gpos:" gpos "gofs:" gofs "epos:" epos "pos:" pos "esz:" esz "sz:" sz "cell:" cell "ref-size:" ref-size "dir:" dir "align:" align]
		]
		
		;Add nested layout if any
		if all [block? sub not empty? sub][
			;probe new-line/skip reduce ["PRE EL ADD-SUB:" "" "spos:" spos "epos:" epos "rfs:" rfs "references:" references "refs:" refs] true 2
			repend ebk ['translate spos]
			repend/only ebk ['push sub]
			;probe reduce ["POST-ADD-SUB:" ]
			;Update reference values
			foreach [key val] body-of rfs [
				val/1: val/1 + epos
				references/:key: val
			]
			clear rfs
			;probe new-line/skip reduce ["POST EL ADD-SUB:" "" "rfs:" rfs "references:" references "refs:" refs] true 2
			spos: sofs: sub: none  
		]
		
		;Adjust element's position and size if asked
		if all [stretch? previous esz/:anti <> last-size/:anti][
			found: none
			case [
				all [last-size/:anti < esz/:anti not join? last-class <> 'shape][
					previous/translate/:anti: last-epos/:anti: epos/:anti
					found: find previous/3/push last-class
					;half: last-size/x / 2
					;tmp-sz: 
					found/3/:anti: last-size/:anti: esz/:anti
				]
				all [last-size/:anti > esz/:anti not split?][
					epos/:anti: last-epos/:anti
					found: find ebk class
					;half: esz/x / 2
					;tmp-sz: 
					found/3/:anti: esz/:anti: last-size/:anti
				]
			]
			;if all [found found/text][probe reduce [tmp-sz half found/text found label-text]
			;	found/text/x: round/to tmp-sz / 2 - half 1
			;]
		]
		
		;Add element's position to group 
		;probe reduce ["ADD ELEMENT:" "pos:" pos  "epos:" epos "esz:" esz] 
		;probe reduce ["PRE GROUP:"  "gpos:" gpos "gofs:" gofs "gsz:" gsz] 
		;probe reduce ["PRE LAYOUT:" "lpos:" lpos "lofs:" lofs "lsz:" lsz]
		
		bk: either at* [lbk][gbk]
		
		;Save previous group's references (it is here to avoid ambiguity with implicit/explicit group start)
		;but only if not ending group-starting-split (as this has been taken care of already in start-split)
		if all [first? not split?] [
			insert refs references
			references: make map! copy []
			;probe new-line/skip reduce ["EL POST-START-GROUP:" "" "references" references "refs" refs "rbks" rbks] true 2
		]
		;Add reference to shape
		if ref [
			;probe new-line/skip reduce ["EL PRE Added reference:" "" "references" references "refs" refs "rbks" rbks] true 2
			references/:ref: reduce [epos esz type* dir] 
			;probe new-line/skip reduce ["EL POST Added reference:" "" "references" references "refs" refs "rbks" rbks] true 2
			append bk ref 
			ref: none
		]
		previous: tail bk
		repend bk ['translate epos]
		repend/only bk ['push ebk]
		bk: gbk
		
		register-size
			
		;probe reduce ["PRE-ELEM:" "MOVE?:" move? "CONNECT?:" connect? "CONNECTED?:" connected? "FIRST?:" first? "JOIN?:" join? "SPLIT*:" split* "FBKS:" fbks "HBKS:" hbks "ssz:" ssz "epos:" epos "gpos:" gpos "lo:" lo]
		;Register position and size of first elements in splitted groups
		if all [first? split* > 0] [ ;first in layout/group but only if in splitted
			either ssz [                 ;if element itself is splitted...
				foreach firsts fbk [     ;... add element's position to firsts
					forall firsts [
						firsts/1: firsts/1 + epos 
						firsts: next firsts
					]
				]
			][
				repend/only fbk [epos esz]
			]
		]
		ssz: none
		;probe reduce ["POST-ELEM/PRE-CONNECT:" "FBKS:" fbks "HBKS:" hbks "lofs:" lofs "lpos:" lpos "lo:" lo "ssz:" ssz "join?:" join?]
		;probe reduce ["PRE-CONNECT:" "connect:" connect? "connected?:" connected? "first?:" first? "epos:" epos "spos:" spos ]
		;if type = 'blank [arrow: false]
		if connect? [
			;probe reduce ["cshape:" cshape-opts "cstyle:" cstyle-opts "arrow:" arrow]
			add-connection
			init-cshape
		]

		if gdir = 'radial [last-first?: first?]
		first?: no   ;next element can't be first (unless in new group/layout)
		
		;prin "NEXT-CONNECT?: " probe 
		connect?: connected?
		stretch?: stretched?

		either at* [
			at*: none
		][
			move?: true
			register-last ;remember position(s) and size of last element if not explixitly positioned
		]
		;probe reduce ["POST GROUP:" "gpos:" gpos "gofs:" gofs "gsz:" gsz] 
		;probe reduce ["POST LAYOUT:" "lpos:" lpos "lofs:" lofs "lsz:" lsz]
		;probe reduce ["LASTS:" "last-pos:" last-pos "last-epos:" last-epos "last-size:" last-size]
	]
	
	register-size: func [
		"Register group's / layout's size"
	][
		either at* [
			;prin "at lsz: " probe 
			lsz: max lsz epos + esz ;+ padding*
			epos: pos
		][
			gsz: max gsz either find [cw ccw] dir [center + radius][epos + esz]
			gofs: min gofs epos
		]
	]
	
	register-last: func [
		"Register basic info about last element"
	][
		last-pos:  pos
		last-epos: epos
		last-size: esz	
		if find [cw ccw] dir [
			last-sweep: sweep*
		]
		last-type: type*
		last-class: class
		last-dir: dir
	]
	
	next-pos: func [
		"Calculate next default position for element"
		/group
	][
		;probe reduce [
		;	"PRE-NEXT-POS:" "last-pos:" last-pos "last-epos:" last-epos "last-size:" last-size "size:" size 
		;	"pos:" pos "epos:" epos "esz:" esz "dir:" dir "space:" space 
		;	"grid*:" grid* "grid-space:" grid-space "ref-size:" ref-size
		;]
		if any [move? gdir = 'radial] [
			switch/default gdir [
				radial [
					pos: case [
						split? [last-epos + sofs + hsz]
						;all [first? = 1 split* = 0][10x0]
						'else [
							switch dir [
								cw [
									last-epos + (last-size / 2) 
									+ (as-pair radius/x * cosine start* radius/x * sine start*) 
									- hsz
								]
							]
						]
					]
					probe reduce [label-text first? "pos" pos "start*" start* "xy" as-pair radius/x * cosine start* radius/x * sine start*]
				]
				circular [pos/:main: last-pos/:main]
			][
				pos/:main: switch dir [
					to-right down [
						either grid* [
							last-pos/:main + (grid-space/:main + 1 * grid*/:main)
						][
							;last element's position + last element's size + space
							last-epos/:main + last-size/:main + space/:main
						]
					]
					to-left up [
						either grid* [
							last-pos/:main - (grid-space/:main + 1 * grid*/:main)
						][
							;last element's position - space - current element's size
							;case [
							;	group [last-epos/:main - space/:main]
							;	first? [pos/:main - esz/:main]
								;'else [
									last-epos/:main - space/:main - either group [size/:main][esz/:main]
								;]
							;]
						]
					]
				]
			]
		]
		;probe reduce ["POST-NEXT-POS:" "pos:" pos "epos:" epos]
		pos
	]
	
	initial-position: func [
		"Calculate next position for element"
	][
		case [
			;Absolute position on lbk
			at* [
				either grid* [
					at* - 1 * grid*
				][
					at*
				]
			]
			;Relative position from current were flow will continue
			pad* [
				pos: next-pos
				pos: pos + either grid* [
					pad* * grid*
				][
					pad*
				]
				pad*: none
				pos
			]
			gap* [
				pos/:main: either find [to-right down] dir [
					either grid* [
						pos/:main + (gap* * grid*/:main)
					][
						pos/:main + last-size/:main + gap*
					]
				][
					either grid* [
						pos/:main - (gap* * grid*/:main)
					][
						;probe 
						pos/:main - gap*
					]
				]
				gap*: none
				pos
			]
			;Just default position
			'else [next-pos]
		]
	]
	
	align-shape: func [
		"Align element in group's row or column"
	][
		;if not at* 
		;if move? [
			;probe reduce ["PRE ALIGN:" label-text "esz:" esz "cell:" cell "sz:" sz "epos:" epos "ref:" ref-size]
			;current element's size doesn't match canonical size
			;if all [not first? esz/:anti <> cell/:anti] [
			if esz/:anti <> cell/:anti [
				switch align [
					middle center [
						epos/:anti: round/to epos/:anti + (cell/:anti - esz/:anti / 2) 1
					]
					bottom right [
						epos/:anti: sz/:anti - esz/:anti 
					]
					;top left []
				] 
				;if all [epos/:anti < 0 not grid*] [
				;	gofs/:anti: min gofs/:anti epos/:anti ;Should we reposition layout instead?
				;]
			]
			;probe reduce ["POST ALIGN:" "esz:" esz "cell:" cell "sz:" sz "epos:" epos]
			if grid* [align-main]
			;align-main
		;]
	]

	align-main: func [
		"Align element in main direction"
	][
		if esz/:main <> cell/:main [
			switch anti-align [
				middle center [
					;probe reduce ["CELL:" cell]
					epos/:main: round/to epos/:main + (cell/:main - esz/:main / 2) 1
				]
				bottom right [
					epos/:main: sz/:main - esz/:main
				]
				;top left []
			]
			if first? = 2 [
				;pos: epos 
				ref-size/:anti: esz/:anti
			]
		]
	]
	
	add-connector: function [
		/split ls lst-epos lst-size lst-type
		/join  fs fst-epos fst-size 
		/glast-dir gldir 
		;/local line-start line-end line-mid mid1 mid2 hsz line
		/extern label-text last-size esz ldir lmain lanti gdir
	][
		arrow*: any [cshape-opts/arrow arrow]
		either all [from* to*][;This is for manual connectors
			set [lst-epos lst-size lst-shape lst-dir] references/:from*
			set [fst-epos fst-size fst-shape fst-dir] references/:to*
			lst-hsz: lst-size / 2
			fst-hsz: fst-size / 2
			if from-dir [
				lst-dir: switch from-dir [
					N ['up]
					S ['down]
					E ['to-right]
					W ['to-left]
					C ['center]
				]
			]
			either to-dir [
				fst-dir: switch to-dir [
					N ['up]
					S ['down]
					E ['to-right]
					W ['to-left]
					C ['center]
				]
			][
				fst-dir: select [to-right to-left to-right up down up] fst-dir
			]
			line-start: lst-epos
			line-end:   fst-epos
			switch lst-dir [
				up       [line-start/x: line-start/x + lst-hsz/x]
				down     [line-start:   line-start + as-pair lst-hsz/x lst-size/y]
				to-right [line-start:   line-start + as-pair lst-size/x lst-hsz/y]
				to-left  [line-start/y: line-start/y + lst-hsz/y]
				center   [line-start:   line-start + lst-hsz]
			]
			switch fst-dir [
				up       [line-end/x: line-end/x + fst-hsz/x]
				down     [line-end:   line-end + as-pair fst-hsz/x fst-size/y]
				to-right [line-end:   line-end + as-pair fst-size/x fst-hsz/y]
				to-left  [line-end/y: line-end/y + fst-hsz/y]
				center   [line-end:   line-end + fst-hsz]
			]
			diff: line-end - line-start
			line-end0: line-end
			either arrow* [
				switch fst-dir [
					up [line-end/y: line-end/y - arrow-size/x]
					down [line-end/y: line-end/y + arrow-size/x]
					to-left [line-end/x: line-end/x - arrow-size/x]
					to-right [line-end/x: line-end/x + arrow-size/x]
				]
				prev: line-end
				half-space: space - arrow-size / 2
			][
				half-space: space / 2
			]
			conn: reduce switch/default ctype [
				ortho [
					case [
						;1. Both on top
						all [lst-dir = 'up fst-dir = 'up][
							y: (min line-start/y line-end/y) - any [cpath/1 half-space/y]
							['line line-start as-pair line-start/x y as-pair line-end/x y line-end0]
						]
						;2. Both on bottom
						all [lst-dir = 'down fst-dir = 'down][
							y: (max line-start/y line-end/y) + any [cpath/1 half-space/y]
							['line line-start as-pair line-start/x y as-pair line-end/x y line-end0]
						]
						;3. Horizontally from front (right) to back (left)
						all [lst-dir = 'to-right fst-dir = 'to-left][
							either line-start/y = line-end/y [
								['line line-start line-end0]
							][
								either empty? cpath [[
									'line line-start 
									as-pair x: line-end/x - half-space/x line-start/y 
									as-pair x line-end/y 
									line-end0
								]][[
									'line line-start 
									as-pair x: line-start/x + half-space/x line-start/y
									as-pair x y: line-start/y + cpath/1
									as-pair x line-end/y 
									line-end0
								]]
							]
						]
						;4. Horizontally from back (left) to front (right)
						all [lst-dir = 'to-left fst-dir = 'to-right][
							either line-start/y = line-end/y [
								['line line-start line-end0]
							][
								['line line-start as-pair x: line-start/x + half-space/x line-start/y as-pair x line-end/y line-end0]
							]
						]
						;5. From top to bottom
						all [lst-dir = 'up fst-dir = 'down][
							either line-start/y - space/y >= line-end/y [
								['line line-start as-pair line-start/x y: line-end/y + half-space/y as-pair line-end/x y line-end0]
							][
								['line line-start as-pair line-start/x y: line-start/y - half-space/y 
								as-pair x: line-start/x + lst-hsz/x + half-space/x y
								as-pair x y: line-end/y + half-space/y
								as-pair line-end/x y line-end0]
							]
						]
						;6. From bottom to top
						all [lst-dir = 'down fst-dir = 'up][
							either line-start/y + space/y <= line-end/y [
								either empty? cpath [[
									'line line-start 
									as-pair line-start/x y: line-end/y - half-space/y 
									as-pair line-end/x y line-end0
								]][[
									'line line-start 
									as-pair line-start/x y: line-start/y + half-space/y 
									as-pair x: line-start/x + cpath/1 y 
									as-pair x y: line-end/y - half-space/y
									as-pair line-end/x y line-end0
								]]
							][
								['line line-start as-pair line-start/x y: line-start/y + half-space/y 
								as-pair x: line-start/x + lst-hsz/x + half-space/x y
								as-pair x y: line-end/y - half-space/y
								as-pair line-end/x y line-end0]
							]
						]
						;7. From top to back (left)
						all [lst-dir = 'up fst-dir = 'to-left][
							either line-start/y - half-space/y >= line-end/y [
								['line line-start as-pair line-start/x line-end/y line-end0]
							][
								['line line-start as-pair line-start/x y: line-start/y - half-space/y
								as-pair x: line-start/x + lst-hsz/x + half-space/x y
								as-pair x y: line-end/y line-end0]
							]
						]
						;8. From bottom to back (left)
						all [lst-dir = 'down fst-dir = 'to-left][
							either line-start/y + half-space/y <= line-end/y [
								['line line-start as-pair line-start/x line-end/y line-end0]
							][
								['line line-start as-pair line-start/x y: line-start/y + half-space/y
								as-pair x: line-start/x + lst-hsz/x + half-space/x y
								as-pair x y: line-end/y line-end0]
							]
						]
						;9. From right to top
						all [lst-dir = 'to-right fst-dir = 'up][
							either line-start/x + half-space/x <= line-end/x [
								['line line-start as-pair line-end/x line-start/y line-end0]
							][
								['line line-start as-pair x: line-start/x + any [first cpath half-space/x] line-start/y
								as-pair x y: line-end/y - half-space/y
								as-pair line-end/x y line-end0]
							]
						]
						;10. From left to top
						all [lst-dir = 'to-left fst-dir = 'up][
							either line-start/x - half-space/x >= line-end/x [
								['line line-start as-pair line-end/x line-start/y line-end0]
							][
								['line line-start as-pair x: line-start/x - any [first cpath half-space/x] line-start/y
								as-pair x y: line-end/y - half-space/y
								as-pair line-end/x y line-end0]
							]
						]
						;11. From right to bottom
						all [lst-dir = 'to-right fst-dir = 'down][
							either line-start/x + half-space/x <= line-end/x [
								['line line-start as-pair line-end/x line-start/y line-end0]
							][
								['line line-start as-pair x: line-start/x + any [first cpath half-space/x] line-start/y
								as-pair x y: line-end/y + half-space/y
								as-pair line-end/x y line-end0]
							]
						]
						;12. From left to bottom
						all [lst-dir = 'to-left fst-dir = 'down][
							either line-start/x - half-space/x >= line-end/x [
								['line line-start as-pair line-end/x line-start/y line-end0]
							][
								['line line-start as-pair x: line-start/x - any [first cpath half-space/x] line-start/y
								as-pair x y: line-end/y + half-space/y
								as-pair line-end/x y line-end0]
							]
						]
						;13. From right to right
						all [lst-dir = 'to-right fst-dir = 'to-right][
							x: (max line-start/x line-end/x) + any [cpath/1 half-space/x]
							['line line-start as-pair x line-start/y as-pair x line-end/y line-end0]
						]
						;14. From left on left
						all [lst-dir = 'to-left fst-dir = 'to-left][
							x: (min line-start/x line-end/x) - any [cpath/1 half-space/x]
							['line line-start as-pair x line-start/y as-pair x line-end/y line-end0]
						]
						;15. From top to right
						all [lst-dir = 'up fst-dir = 'to-right][
							case [
								cpath/1 [[
									'line line-start 
									as-pair line-start/x y: line-start/y - half-space/y 
									as-pair x: line-start/x - cpath/1 y
									as-pair x: line-end/x + half-space/x y
									as-pair x line-end/y line-end0
								]]
								all [
									0 - half-space/y <= diff/y 
									0 - half-space/x <= diff/x
								][[
									'line line-start as-pair line-start/x line-end/y line-end0
								]]
								'else [[
									'line line-start 
									as-pair line-start/x y: line-start/y - half-space/y
									as-pair x: line-end/x + half-space/x y
									as-pair x y: line-end/y line-end0
								]]
							]
						]
						;16. From bottom to right
						all [lst-dir = 'down fst-dir = 'to-right][
							case [
								cpath/1 [[
									'line line-start 
									as-pair line-start/x y: line-start/y + half-space/y 
									as-pair x: line-start/x - cpath/1 y
									as-pair x: line-end/x + half-space/x y
									as-pair x line-end/y line-end0
								]]
								all [
									    half-space/y <= diff/y 
									0 - half-space/x <= diff/x
								][[
									'line line-start as-pair line-start/x line-end/y line-end0
								]]
								'else [[
									'line line-start 
									as-pair line-start/x y: line-start/y + half-space/y
									as-pair x: line-end/x + half-space/x y
									as-pair x y: line-end/y line-end0
								]]
							]
						]
					]
				]
				straight [;probe reduce [dir lst-dir fst-dir]
					case [
						all [lst-dir = dir fst-dir = dir][
							line-end/:lanti: line-end0/:lanti: line-start/:lanti
							if arrow* [
								line-end/:lmain: line-end0/:lmain - arrow-size/x 
								prev: line-end
							]
							['line line-start line-end0]
						]
						all [lst-dir <> dir fst-dir = select [up down up to-left to-right to-left] dir][
							mid: line-start
							switch lst-dir [
								to-right down [mid/:lanti: mid/:lanti + any [cpath/1 half-space/:lanti]]
								to-left up    [mid/:lanti: mid/:lanti - any [cpath/1 half-space/:lanti]]
							]
							line-end/:lanti: line-end0/:lanti: mid/:lanti
							if arrow* [
								line-end/:lmain: line-end0/:lmain - arrow-size/x 
								prev: line-end
							]
							ret: ['line line-start mid line-end0]
						]
					]
				]
			][
				['line line-start line-end0]
			]
			insert conn [fill-pen off]
			conn
		][;This is for automatic connectors
			ls: any [ls 0x0]
			lst-epos: any [lst-epos last-epos]
			lst-size: any [lst-size last-size]
			lst-type: any [lst-type last-type]

			fs: any [fs 0x0]
			fst-epos: any [fst-epos epos]
			fst-size: any [fst-size esz]
			hsz: fst-size / 2

			either gdir = 'radial [
				prev: line-start: lst-epos + hsz
				line-end: line-end0: fst-epos + hsz + either split? [prev][0x0]
				diff: line-end - line-start
				angle: arctangent2 diff/y diff/x
				switch lst-type [
					ellipse  [
						stp: hsz/y - hsz/x / 90
						ang: absolute angle
						either ang % 180 <= 90 [
							len: ang * stp + hsz/x
						][
							len: (180 - (ang % 180) * stp + hsz/x)
						]
						prev: line-start: line-start + ps: as-pair len * cosine angle len * sine angle
						line-end: line-end0: line-end - ps
					]
					box text [
						
					]
					circle   [
						
					]
					square   []
					diamond  []
				]
			][
				ldir: any [gldir dir]
				lmain: pick [y x] to logic! find [up down] ldir
				lanti: select [x y x] lmain

				line-start: lst-epos
				line-end: ls + fst-epos 

				;probe reduce ["CONNECTOR:" ldir lmain lanti "ls:" ls "last:" lst-epos lst-size "this:" fst-epos hsz]
				either find [to-right down] ldir [
					line-start/:lmain: line-start/:lmain + lst-size/:lmain 
					line-start/:lanti: line-start/:lanti + (round/to lst-size/:lanti / 2 1)
					line-end/:lanti: line-end/:lanti + hsz/:lanti
				][
					line-start/:lanti: line-start/:lanti + (round/to lst-size/:lanti / 2 1)
					line-end/:lmain: line-end/:lmain + fst-size/:lmain 
					line-end/:lanti: line-end/:lanti + hsz/:lanti
				]
				line-end0: line-end
				if arrow* [
					line-end/:lmain: line-end/:lmain - arrow-size/x
					;probe reduce ["ENDS:" line-end line-end0]
				]
				line-mid: line-start + line-end / 2
				pos0: line-start
				if line-end0/:lmain - line-start/:lmain > space/:lmain [
					line-mid/:lmain: line-end0/:lmain - (round/to space/:lmain / 2 1)
					pos0/:lmain: line-end0/:lmain - space/:lmain
					if arrow* [line-mid/:lmain: line-mid/:lmain - round/to arrow-size/x / 2 1]
				]
			]
			
			conn: reduce either all [
				gdir <> 'radial 
				2 >= absolute line-start/:lanti - line-end/:lanti
			][
				['line prev: line-start line-end0] ;"prev" is used to orient arrowhead 
			][
				switch ctype [
					line [['line prev: line-start line-end0]]
					ortho [
						mid1: line-start
						mid2: line-end0
						mid1/:lmain: mid2/:lmain: line-mid/:lmain
						['fill-pen 'off 'line line-start mid1 prev: mid2 line-end0]
					]
					spline [
						m8: line-end - pos0 / 7 ;line-start
						mid1: line-start;pos0
						mid2: line-end
						mid1/:lmain: mid2/:lmain: line-mid/:lmain
						mid1/:lmain: mid1/:lmain - m8/:lmain
						mid1/:lanti: mid1/:lanti + m8/:lanti
						mid2/:lmain: mid2/:lmain + m8/:lmain
						mid2/:lanti: mid2/:lanti - m8/:lanti
						ret: ['fill-pen 'off 'spline line-start mid1 mid2 line-end]
						if arrow* [append ret ['line prev: line-end line-end0]]
						ret
					]
					sline [
						dr: line-end/:lanti - line-start/:lanti
						dr: dr / dr': absolute dr 
						rad: absolute line-end/:lmain - line-mid/:lmain
						pos1: pos2: prev: line-mid
						prev/:lanti: line-end/:lanti
						if arrow* [prev: line-end]
						pos1/:lanti: line-start/:lanti + (dr * rad)
						pos2/:lanti: line-end/:lanti - (dr * rad)
						pos1: either 2 * rad >= dr' [pos2: line-mid][pos1]
						;probe 
						ret: reduce [
							'fill-pen 'off
							'move line-start
							'line pos0
							'arc pos1 rad rad 0 
							'line pos2
							'arc line-end rad rad 0 
						]
						either any [
							all [ldir = 'down dr < 0] 
							all [ldir = 'to-right dr > 0]
						][
							 insert at ret 12 'sweep 
						][	append ret 'sweep]
						if arrow* [repend ret ['line line-end0]]
						['shape ret]
					]
					arc [
						dr: line-end/:lanti - line-start/:lanti
						dr: dr / absolute dr
						rad: absolute line-end - line-mid
						;pos0: line-start
						;pos0/:lmain: line-mid/:lmain - rad/:lmain
						cent1: cent2: line-mid
						cent1/:lmain: pos0/:lmain
						cent2/:lmain: line-end/:lmain
						start1: switch ldir [
							to-right [pick [0 -90] dr < 0]
							down     [pick [0 90] dr < 0]
						]
						start2: 180 + start1
						sweep: 90 ; -1 * dr * 90
						;sweep2: -1 * sweep1
						;probe reduce ["dr" dr "rad" rad "sweep" sweep]
						;probe reduce ["cent1" cent1 "start1" start1 ];"sweep1" sweep1]
						;probe reduce ["cent2" cent2 "start2" start2 ];"sweep2" sweep2]
						ret: [
							'fill-pen 'off
							'line line-start pos0
							'arc cent1 rad start1 sweep
							'arc cent2 rad start2 sweep
						]
						if arrow* [append ret ['line prev: line-end line-end0]]
						ret
					]
					straight [
						case [
							split? [
								line-start/:lanti: line-end/:lanti
							]
							join? [
								line-end/:lanti: line-end0/:lanti: line-start/:lanti
							]
						]
						prev: line-end
						['line line-start line-end0]
					]
				]
			]
		]
		if all [cstyle-opts not empty? cstyle-opts] [
			insert conn cstyle-opts
		]
		repend gbk ['push conn]
		;probe reduce ["TYPE:" type]
		if all [arrow* type <> 'guide] [
			;probe reduce ["SO:" shape-opts text-opts ]
			;probe reduce ["prev:" prev]
			;save-element
			lst-sz: esz
			label-text: none
			add-shape/arr
			apos: line-end0
			apos/x: apos/x - esz/x
			apos/y: apos/y - round/to esz/y / 2 1
			ang: line-end0 - prev
			angle: arctangent2 ang/y ang/x
			rpos: as-pair esz/x round/to esz/y / 2 1
			;probe reduce ["ARROW:" arrow* "apos" apos "angle" angle esz]
			;probe reduce ["ARR-ebk:" ebk]
			;repend conn ['rotate angle line-end ebk]
			append gbk 'push
			repend/only gbk ['translate apos 'rotate angle rpos ebk];
			esz: last-size: lst-sz
			;probe reduce ["LAST:" last-pos last-epos last-size]
			;restore-element
		]
	]
	
	add-connection: func [/local ps pz lst tk len][
		 ;probe reduce ["HERE-1" "FBKS:" fbks "HBKS:" hbks]
		 ;either from* []
		 case [
			all [from* to*][
				add-connector
			]
			all [not first? split?] [
				lst: reduce [last-epos last-size last-type] ; these are last before splitted element is added (restored)
				ps: epos  ;record
				pz: esz   ;record
				if all [
					frst: take/last last fbks 
					lst/2 <> 0x0
				][
					foreach [epos esz] frst [
						;probe reduce ["PS:" ps "LO:" lo "EPOS:" epos]
						add-connector/split ps - lo lst/1 lst/2 lst/3
					]
				]
				epos: ps  ;restore
				esz:  pz  ;restore
				fbk: last fbks
			]
			join? [
				if tk: take/last hbks [
					len: (length? tk) / 2
					foreach [a b] tk [
						add-connector/split 0x0 last-epos - lo + a b last-type
					]
				]
				join?: false
			]
			first? = 2 [
				ps: group-last-epos - gpos
				add-connector/split/glast-dir 0x0 ps group-last-size last-type group-last-dir ;?? last-type
			]
			'else [add-connector]
		]
	]

	; Add group to layout
	add-gbk: func [
		"Add group to layout"
		/end
		/local fst lst hb gp
	][
		either empty? gbk [
			false  ;Nothing to add
		][
			;probe "GBK-ADD:" 
			;probe reduce ["PRE LAYOUT" "lpos:" lpos "lofs:" lofs "lsz:" lsz]
			;probe reduce ["PRE GROUP" "gpos:" gpos "gofs:" gofs "gsz:" gsz]
			;gpos: 0 - gofs
			
			;if find [above rear] gdir [
			;	gpos/:main: gpos/:main - gsz/:main
			;]
			;lsz: max lsz either fix? [gpos + gsz][gpos + gsz - gofs];(gsz - gofs)
			;lofs: min lofs either fix? [gpos][gpos + gofs]
			;probe reduce ["PRE:" "fix?" fix? "gdir" gdir "lgdir" lgdir "gpos" gpos "gofs" gofs "gsz" gsz "lgpos" lgpos "lgsz" lgsz "lpos" lpos "lofs" lofs ]
			lgpos: either fix? [gpos][
				switch gdir [
					across rear [
						switch lgdir [
							return [
								switch ghalign [
									left   [gpos - gofs]
									center [as-pair gpos/x + round/to lgpos/x + (lgsz/x / 2) - 
												   (gpos/x + gofs/x + (gsz/x - gofs/x / 2)) 1  
													gpos/y - gofs/y  ]
									right  [as-pair lgpos/x + lgsz/x - gsz/x
													gpos/y - gofs/y]
								]
							]
							next [
								switch gvalign [
									top    [gpos - gofs]
									middle [as-pair gpos/x - gofs/x  
													gpos/y + round/to lgpos/y + (lgsz/y / 2) - 
												   (gpos/y + gofs/y + (gsz/y - gofs/y / 2)) 1]
									bottom [as-pair gpos/x - gofs/x lgpos/y + lgsz/y - gsz/y]
								]
							]
						]
					]
					below above [
						switch lgdir [
							return [
								switch gvalign [
									top    [gpos - gofs]
									middle [as-pair gpos/x - gofs/x  
													gpos/y + round/to lgpos/y + (lgsz/y / 2) - 
												   (gpos/y + gofs/y + (gsz/y - gofs/y / 2)) 1]
									bottom [as-pair gpos/x - gofs/x lgpos/y + lgsz/y - gsz/y]
								]
							]
							next [
								switch ghalign [
									left   [gpos - gofs]
									center [as-pair gpos/x + round/to lgpos/x + (lgsz/x / 2) - 
												   (gpos/x + gofs/x + (gsz/x - gofs/x / 2)) 1  
													gpos/y - gofs/y  ]
									right  [as-pair lgpos/x + lgsz/x - gsz/x
													gpos/y - gofs/y]
								]
							]
						]
					]
					radial [
						gpos
						;last-epos + (last-size / 2) 
						;	+ (as-pair (radius/x * cosine start*) (radius/x * sine start*)) 
						;	- hsz
					]
				]
			]
			lgsz: gsz - gofs
			;probe reduce ["element" label-text "fix?" fix? "gpos" gpos "gofs" gofs "gp" gp]
			repend lbk ['translate lgpos] ;
			repend/only lbk ['push gbk]
			;Add group position to firsts and lasts
			if not empty? fbk [
				;probe reduce ["PRE-ADD-GBK:" "fbks:" fbks "lpos" lpos "lofs" lofs "gpos" gpos "gofs" gofs "epos" epos]
				firsts: last fbk
				forall firsts [firsts/1: firsts/1 + lgpos firsts: next firsts]
			;	change fst: skip tail last fbks -2 fst/1 + gpos ;firsts
				;probe reduce ["POST-ADD-GBK:" "fbks:" fbks]
			]
			;probe reduce ["PRE-ADD-GBK:" "label:" label-text "HBKS:" hbks "gofs:" gofs "gpos:" gpos "lofs:" lofs "lpos:" lpos "l-po:" last-epos "join?:" join? "split*:" split*]
			either empty? hbks [
				append/only hbks lasts: reduce [lgpos + last-epos last-size]
			][
				lasts: last hbks
				either join? [
					forall lasts [
						lasts/1: lasts/1 + lgpos + last-epos; gofs
						lasts: next lasts
					]
					if not single? hbks [ 
						hb: take/last hbks
						append lasts: last hbks hb
					]
					join?: false
				][
					;probe "HERE"
					repend lasts [lgpos + last-epos last-size]
				]
			]
			
			;Update references
			rfs: references
			;probe new-line/skip reduce ["PRE ADD-GBK:" "" "references" references "refs" refs "rbks" rbks] true 2
			references: either empty? refs [make map! copy []][take refs]
			if not empty? rfs [
				foreach [key val] body-of rfs [
					val/1: val/1 + lgpos
					references/:key: val
				]
			]
			clear rfs
			;probe new-line/skip reduce ["POST ADD-GBK:" "" "references" references "refs" refs "rbks" rbks] true 2
			gpos: lgpos                 ;adjust gpos
			lgpos: lgpos + gofs         ;normalize last group's position
			;Adjust layout data
			lsz:  max lsz  lgpos + lgsz 
			lofs: min lofs lgpos
			;probe reduce ["POST:" "lgpos" lgpos "lgsz" lgsz "lpos" lpos "lofs" lofs "lsz" lsz]
			unless end [
				lgfix?: fix?
				fix?: false
				;probe reduce ["POST-ADD-GBK:" "HBKS:" hbks "gofs:" gofs "gpos:" gpos "lofs:" lofs "lpos:" lpos "l-po:" last-epos "join?:" join? "split*:" split*]
				gbk: make block! 30 
				;probe reduce ["POST GROUP" "gpos:" gpos "gofs:" gofs "gsz:" gsz]
				;probe reduce ["POST LAYOUT" "lpos:" lpos "lofs:" lofs "lsz:" lsz]
				init-shape
				first?: 2
				bk: gbk
			]
			true
		]
	]
	
	;add-lbk: does [
	;	
	;]
	
	set-direction: func [
		"Sync direction vars to current direction"
	][
		set [main anti] switch dir [
			to-left to-right cw ccw [[x y]]
			up down [[y x]]
		]
		if old-dir <> dir [ref-size/:anti: last-size/:anti]
	]
	
	start-group: func [
		"Set up new group with default direction and optionally advance to new position"
		/local pos
	][ ;across, below, rear, above -> change of dir occurs after next step 
		;First, append previous group, move if it was not empty
		move?: add-gbk

		group-last-pos:  gpos - gofs + last-pos
		group-last-epos: gpos - gofs + last-epos
		group-last-size: last-size
		group-last-dir:  dir
		
		;In case last group ended with splitted element
		;if join? [take/last fbks take/last hbks join?: false]
		;prin "move?: " probe move?
		;print ["PRE-start-group:" "at*:" at* "pad*:" pad* "grid*:" grid* "dir:" dir 
		;       "gpos:" gpos "last-pos:" last-pos "pos:" pos "size:" size "space:" space]
		case [
			at*   [
				gpos: either grid* [at* - 1 * grid*][at*] 
				at*: none
			]
			pad*  [
				if move? [gpos: gpos + next-pos/group]
				gpos: gpos + either grid* [pad* * grid*][pad*] 
				pad*: none
			]
			;grid* [
			;	if move? [gpos/:main: last-pos/:main + grid*/:main]
			;]
			gap*  [
				if move? [gpos: gpos + next-pos/group]
				either grid* [
					gpos/:main: gpos/:main - (grid-space/:main * grid*/:main) + (gap* * grid*/:main)
				][
					gpos/:main: gpos/:main - space/:main + gap*
				]
				gap*: none
			]
			'else [
				if move? [
					;probe reduce ["PRE GPOS:" "gpos:" gpos "last:" last-pos last-epos last-size "el:" pos epos "ref:" ref-size "main:" main "anti:" anti]
					
					gpos: gpos + next-pos/group
					;probe pos: gpos + next-pos/group  ;- gofs 
					;gpos/:main: pos/:main
					;gpos/:anti: pos/:anti + either grid* [last-pos/:anti][last-epos/:anti]
					;probe reduce ["POST GPOS:" "gpos:" gpos "size:" size]
				]
			]
		]
		pos: epos: esz: gofs: gsz: 0x0
		gmain: switch gdir [
			across rear ['x]
			below above ['y]
		]
		ganti: select [x y x] gmain
		fix?: yes
		dir: next-dir
		set-direction
		;init-last
		if first? <> 1 [first?: 2]
		ref-size: size
		move?: no
		connect?: no  ;by default group is not connected
		stretch?: no
		;print ["POST-start-group:" "gpos:" gpos "main:" main "anti:" anti "at*:" at* "pad*:" pad* "ref-size:" ref-size "group-last-epos:" group-last-epos "group-last-dir:" group-last-dir]
	]
	
	next-group: func [
		"Start next group in main position"
		/ret
	][
		add-gbk
		either gdir = 'radial [
			start*: start* + angle
		][
			gpos/:gmain: either ret [lgpos/:gmain][
				lgpos/:gmain + lgsz/:gmain + either grid* [
					grid-space/:gmain * grid*/:gmain
				][
					space/:gmain
				]
			]
			gpos/:ganti: either ret [
				lgpos/:ganti + lgsz/:ganti + either grid* [
					grid-space/:ganti * grid*/:ganti
				][
					space/:ganti
				]
			][lgpos/:ganti]
			dir: select [across to-right rear to-left below down above up] gdir
			set-direction
		]
		lgdir: pick [return next] ret

		init-last
		move?: connect?: stretch?: false ;
		;probe reduce ["POST-NEXT:" "gpos:" gpos "ret:" ret]
	]
	
	save-state: func [
		"Save layout and group states to be restored later"
	][
		append/only lbks lbk 
		append/only gbks gbk 
		repend/only lopts [origin lpos lofs lsz padding margin size space grid* last-pos last-epos last-size last-type move? first? connected? connect? join? stretched? stretch? previous start* angle]
		repend/only gopts [gpos gofs gsz pos dir main anti align valign halign talign side ref-size fix? gmain ganti lgpos lgsz lgdir]
		insert refs references
		append/only rbks refs
		refs:       make block! 10
		references: make map! copy []
		rfs:        make map! copy []
		insert ref-marks ref
		ref: none
		;probe reduce ["SAVED STATE:" "rbks" rbks]
	]

	restore-state: func [
		"Restore layout and group state"
	][
		;PRINT ["PRE RESTORE STATE:" "spos:" spos "lpos:" lpos "lofs:" lofs "padd:" padd "padding:" padding "origin:" origin "ssz:" ssz ]
		;prin "SUB: " probe sub
		lbk:     take/last lbks
		bk: gbk: take/last gbks
		;probe "RESTORE STATE:"
		;prin "  lopts: " probe 
		set [origin lpos lofs lsz padding margin size space grid* last-pos last-epos last-size last-type move? first? connected? connect? join? stretched? stretch? previous start* angle] take/last lopts
		;prin "  gopts: " probe 
		set [gpos gofs gsz pos dir main anti align valign halign talign side ref-size fix? gmain ganti lgpos lgsz lgdir]  take/last gopts
		refs: take/last rbks
		references: take refs
		ref: take ref-marks
		;probe new-line/skip reduce ["RESTORED STATE:" "" "refs" refs "references" references "rbks" rbks "rfs" rfs] true 2
	]
	
	save-element: func [
		"Save element state to be restored later"
	][
		append/only ebks type
		repend/only eopts [style-opts shape-opts font-opts text-opts label-text]
	]

	restore-element: func [
		"Restore element's state"
	][
		type:    take/last ebks
		;probe "RESTORE ELEMENT:"
		;prin "  eopts: " probe 
		set [style-opts shape-opts font-opts text-opts label-text] take/last eopts
		padding*: any [shape-opts/padding padding]
		size*:    any [shape-opts/size size]
		;fixed*:   any [shape-opts/fixed fixed]
		;if not fixed* = true [
			put shape-opts 'size max size* ssz + padding*
		;]
	]
	
	record-sub: func [
		"Record sub-layout"
		/shape
		/local padd val
	][
		padd: either shape [any [origin padding]][0x0]
		spos: lpos - lofs + padd ;
		ssz:  lsz - lofs + padd ;
		sofs: lofs
		sub:  lbk
		;probe new-line/skip reduce ["PRE RECORD-SUB" "" "references" references "rfs" rfs] true 2
		rfs: references
		foreach val values-of rfs [
			val/1: val/1 + spos
		]
		;probe new-line/skip reduce ["POST RECORD-SUB" "" "references" references "rfs" rfs] true 2
	]
	
	start-layout: func [
		"Start new layout to gather inner/sub contents of a shape"
	][
		if first? [;Time to save references and start anew for new layout
			;probe new-line/skip reduce ["PRE START-LAYOUT:" "" "references" references "refs" refs "rbks" rbks] true 2
			insert refs references
			references: make map! copy []
			;probe new-line/skip reduce ["POST START-LAYOUT:" "" "references" references "refs" refs "rbks" rbks] true 2
		]
		save-state
		save-element
		;lpos: gpos:   0x0 
		init-lbk
	]
	
	end-layout: func [
		"End new layout as contents of a shape"
	][
		add-gbk/end      ;Add last group (or first if single) to sub
		record-sub/shape ;Remember sub-layout vars
		restore-state    ;Restore parent layout and group state 
		restore-element  ;Restore element who's sub was filled
		;first?: either connected? [1][false];Fishy!!
		first?: false
	]
	
	turn-direction: func [
		"Turn direction of flow in group"
		'turn [word!]
	][
		dir: switch/default turn [
			cw  [select [up to-right down to-left up] dir]
			ccw [select [up to-left down to-right up] dir]
		][
			cause-error 'user 'message rejoin [
				"Not valid argument for turn-direction: " turn
			]
		]
		set-direction
		;main:    pick [y x] main = 'x
		;anti: pick [x y] main = 'x
	]
	
	flatten: func [
		"Fold blocks into first"
		block
	][
		foreach blk next block [
			append first block blk
		]
		clear next block
	]
	
	start-split: func [
		"Make new layout with threads and place it as single element"
	][
		;probe reduce ["START SPLIT"]
		;If split starts group, it needs to be taken care here
		if first? [;Time to save references and start anew for new layout
			;probe new-line/skip reduce ["PRE START-SPLIT:" "" "references" references "refs" refs "rbks" rbks] true 2
			insert refs references
			references: make map! copy []
			;probe new-line/skip reduce ["POST START-SPLIT:" "" "references" references "refs" refs "rbks" rbks] true 2
		]
		save-state
		if gdir = 'radial [
			branches: count-branches
			either compact? [
				angle: 60
				start*: start* - (branches - 1 * angle / 2)
			][
				angle: 360 / (branches + pick [1 0] to logic! any [split* > 0 not last-first?])
				if not fix? [start*: start* - 180 + angle]
			]
			probe reduce ["PRE-SPLIT:" "branches:" branches pick [1 0] not last-first? "angle:" angle "start*:" start* "lofs" lofs "lsz" lsz "lpos" lpos]
			probe reduce ["group-last-epos" group-last-epos]
		]
		init-lbk
		;probe reduce ["PRE-SPLIT:" "connect?:" connect? "connected?:" connected? "FIRSTS-0:" fbks "LASTS-0:" hbks]
		;probe reduce ["PRE-SPLIT" "element" label-text "fix?" fix?]
		;prin "SPLIT LEVEL: " probe 
		split*: split* + 1
	]
	
	end-split: func [
		"Join threads"
	][
		add-gbk       ;add last group to sublayout
		flatten last fbks
		;probe reduce ["POST flatten:" "FBKS:" fbks]
		if not single? fbks [
			firsts: take/last fbks
			append last fbks firsts
		]
		fbk: last fbks
		;probe reduce ["PRE-RESTORE:" connect? connected? "FIRSTS-0:" fbks "LASTS-0:" hbks]
		record-sub    ;record sublayout geometry
		lo: lofs
		restore-state ;back to previous level
		probe reduce ["POST-SPLIT" "element" label-text "fix" fix? "lofs" lofs "lsz" lsz "lpos" lpos]
		;probe reduce ["POST-RESTORE:" connect? connected? "FIRSTS-0:" fbks "LASTS-0:" hbks]
		init-shape           ;start new element
		ebk: make block! 20
		label-text: none
		esz: ssz             ;set element's size to sublayout's size

		split?: yes
		add-element          ; add splitted element (may be splitted itself?)
		split?: no
		
		;if connected? [connect?: yes]
		;prin "SPLIT LEVEL: " probe 
		split*: split* - 1
		join?: yes
	]

	count-branches: func [
		"Count branches in group (for radial layouts)"
		/local count
	][
		count: 0 
		parse p/1 [any [['| | 'return] (count: count + 1) | skip]]
		count + 1
	]
	
	show-grid: does [
		repend bk [
			'fill-pen 'pattern grid reduce [ 
				'fill-pen clr 'pen silver ;'line-width 0.5
				'line 0x0 as-pair grid/x 0
				'line 0x0 as-pair 0 grid/y 
			]
		]
	]
	
	;=========================================================
	;                       RULES
	;=========================================================
	
	alignment: [horizontal | vertical]
	horizontal: [set halign ['left | 'right  | 'center]]
	vertical:   [set valign ['top  | 'middle | 'bottom]]
	labels-side: ['outside | 'inside] 
	labels-align: [
	    'top    | 'middle | 'bottom
	  | 'left   | 'center | 'right  
	  | 'top-left    | 'top-right
	  | 'bottom-left | 'bottom-right 
	  | 'left-top    | 'left-bottom
	  | 'right-top   | 'right-bottom
	]
	group-alignment: [group-horizontal | group-vertical]
	group-horizontal: [set ghalign ['left | 'right  | 'center]]
	group-vertical:   [set gvalign ['top  | 'middle | 'bottom]]
	
	color: [c:
	  ahead word! if (tuple? attempt [get c/1]) skip (clr: c/1)
	  | set clr tuple!
	  | issue! if (clr: hex-to-rgb c/1)
	  | set clr 'off
	]
	
	font: []
	
	styling-options: [s:
		opt ['fill-pen | 'fill] color 
				   (repend bk ['fill-pen clr])
	  | 'pen color (repend bk ['pen clr])
	  ;--------------
	  | ['line-width | 'line-cap | 'line-join | 'anti-alias] skip 
	               (append bk copy/part s 2)
	  ;--------------
	  | 'font (append bk 'font) [f:
		  color    (_fnt_: make font! compose [color: (clr)])
		| 'anti-alias ['off | 'on] 
		           (_fnt_: make font! compose [antialias: (f/2)])
		| ['bold | 'italic | 'underline] 
		           (_fnt_: make font! compose [style: (to-lit-word f/1)])
	    | [word! | path!] (_fnt_: resolve-font f/1)
		| block!   (_fnt_: make font! f/1)
		| integer! (_fnt_: make font! compose [size: (f/1)])
		| string!  (_fnt_: make font! compose [name: (f/1)])
	    ] (append bk dummy/font: _fnt_)
	]
	;Layout options either add styling to layout or group (depending on `bk` <- `lbk` or `gbk`)
	;or set option-words to be used in following placements
	layout-options: [
		;Font, colors and lines
	    styling-options
	  ;-------Default label options--------
	  | 'labels some [
	      set side labels-side 
		| set talign labels-align 
		| 'padding [
		    set text-padding [pair! | integer!] 
		  | 'off (text-padding: none)]
		| 'adjust     set adjust   pair!
		]
	  | set side labels-side 
	  | 'adjust     set adjust   pair!
	  ;-------Default layout/group options-------
	  | 'groups some group-alignment
	  | alignment                              ;Set alignment of elements in groups
	  | 'grid      [[set grid     pair!        ;Switch grid-mode on/off
					;?? This doesn't work as wanted, needs additional level to show
	                | (grid: size)
					] opt ['show (show-grid)] 
	    |          'off  (grid: none)]
	  | 'space      set space    pair!     ;Set space between elements
	  | 'arrow     [
		    'as a: set arrow shapes (arrow-shape: arrow) 
		  | 'off (arrow: false) 
		  | (arrow: arrow-shape)
		]
	  ;| 'connected    (connected?: connect?: yes)
	  ;| 'disconnected (connected?: connect?: no)
	  | connection
	  | 'stretched   (stretched?: true)
	  | 'unstretched (stretched?: false)
	  ;-------Default shape options-------
	  | 'shape      set shape    word!     ;opt shape-def                 ;
	  | 'size       set size     pair!     ;Set default size for elements
	                (ref-size: size)       ;Set default size for col/row (can change when direction is altered)
	  | 'padding    set padding  [pair! | integer!];Space to be left between sublayout and shape's border, optional for labels too
	  | 'margin     set margin   [pair! | integer!];Space left between outside label and shape's border
	  | 'step       set step     [pair! | number!] ;Step on shape's side to be used for polygon configurations
	  | 'fixed   s: [                              ;For element if label is inside: 
	      ['width | 'height] (fixed:   s/2)           ;don't auto-change this dimension
		| 'off (fixed:   false)                       ;auto-change both dimensions (default)
		| (fixed:   true)                             ;use current size; don't bother about label size
		]
	  | 'growing s: [                              ;For element if label is outside: 
	      ['width | 'height] (growing: s/2)           ;adjust this dimension to label-size
		| 'off (growing: false)                       ;don't adjust size to label (default)
		| (growing: true)                             ;adjust any dimension to label-size
		]
	  | 'tight   s: [                              ;For element if label is inside
	      ['width | 'height] (tight:   s/2)           ;Diminish this dimension to label's dimension
		| 'off (tight:   false)                       ;Don't diminish element's size to label dimensions
		| (tight:   true)                             ;Draw element tight around label + label's padding
		]
	  | 'max [                                     ;Limit max size of element
		  'width  set max-width  integer!
		| 'height set max-height integer!
		| set         max-size   pair!
		]
	  | 'min [                                     ;Limit min size of element
		  'width  set min-width  integer!
		| 'height set min-height integer!
		| set         min-size   pair!
		]
	  | 'center     set center pair!               ;Set center for circular layout
	  | 'radius     set radius [pair! | integer!]  ;Set radius for circular layout
		(if integer? radius [radius: to pair! radius])
	  | 'start      set start integer!
		(start*: start);Set starting angle for circular layout
	  | 'sweep      set sweep integer!             ;Set sweep-angle for circular layout
	  | 'compact    (compact?: yes)
	  | 'slack      (compact?: no)
	  | 'fix        (fix?: yes)
	  | 'unfix      (fix?: no)
	]
	
	style-definition: [
	  'style s: set-word! [shape-def | edge-def]
	]
	
	set-group: [[
	  set gdir [
	      'across   (next-dir: 'to-right) 
	    | 'rear     (next-dir: 'to-left)
	    | 'below    (next-dir: 'down) 
	    | 'above    (next-dir: 'up)
		| ['circular | 'radial ];| 'spiral] 
		  opt 'cw   (next-dir: 'cw) 
		  opt ['ccw (next-dir: 'ccw)] 
	  ] (start-group) any layout-options
	| ['| | 'return] (next-group/ret) 
	    any layout-options
	| 'next          (next-group)
	] (init-group) ;any layout-options
	]

	direction: [
	  ahead ['down | 'up | 'to-left | 'to-right] (old-dir: dir) 
	  set dir skip
	  opt [set gap* integer!]
	  any alignment (set-direction)
	]
	
	layout-directive: [s: 
	    set-group 
	  | direction
	  
	  | 'origin    set origin pair!          ;to be added to layout position
	  
	  | 'space     set space  pair!          ;set space dimensions
	  | 'size      set size   pair!          ;set default size for elements
	               (ref-size: size)          ;set default size for col/row (can change when direction is altered)
	  
	  | 'at        set at*    pair!          ;place element or group absolutely, don't adjust group or layout offset
	  | 'pad       set pad*   pair!          ;place element or group relative to default position and continue from there
	  ;| 'lift      set lift*  integer!       ;place element or group relatively in anti direction but continue normally in main direction
	  | ahead block! (start-split) into rule (end-split)   ;start new layout, place as single element with sub-layout
	  ;| ahead hash!  (start-fork)  into rule (join-fork)    ;start bunch of groups, place individually relative to last-position 
	]
	
	;; SHAPE ;;
	shapes: [
	    'box 
	  | 'square
	  | 'roundbox
	  | 'halfround
	  | 'bar
	  | 'diamond
	  | 'parallelogram
	  | 'trapez
	  | 'triangle
	  | 'pentagon
	  | 'hexagon
	  ;| 'heptagon
	  | 'octagon
	  | 'polygon
	  | 'star
	  | 'ellipse
	  | 'circle
	  | 'sector
	  ;| 'trefoil
	  ;| 'quatrefoil
	  | 'corner
	  | 'line
	  | 'hline
	  | 'vline
	  | 'ortho 
	  | 'spline
	  | 'sline
	  | 'arc
	  | 'curve 
	  | 'sector
	  | 'cross
	  | 'plus
	  | 'charon
	  | 'kite
	  | 'dart
	  | 'text
	  | 'stick-man
	  | 'blank
	  | 'guide
	]
	
	shape-type: [
		set type shapes 
		(init-shape label-text: none)
	]
	
	shape-def: [
		any [s:
		  shape-options
		| style-options
		| text-options
		| font-options
		| sub-options
		]
		(add-shape) 
	]
	
	shape-options: [
	    copy points some pair! (
		  put shape-opts 'size either single? points [points/1][points]
	    )
	  | integer!                    (put shape-opts 'int     s/1)
	  | 'width  [number!]           (put shape-opts 'width   s/2)
	  | 'height [number!]           (put shape-opts 'height  s/2)
	  | ['top  | 'middle | 'bottom] (put shape-opts 'valign  s/1)
	  | ['left | 'right  | 'center] (put shape-opts 'halign  s/1)
	  | 'padding [pair! | integer!] (put shape-opts 'padding s/2)
	  | 'margin  [pair! | integer!] (put shape-opts 'margin  s/2)
	  | 'step    [pair! | number!]  (put shape-opts 'step    s/2)
	  | 'data skip                  (put shape-opts 'data    s/2) ;for type-specific additional data ??
	  | directions ;path of compass points or 'C (center) to describe line, spline, sline or polygon
	                                (put shape-opts 'point   s/1) ;direction of pointing (or cutting) or path of cardinal points if any
	  | 'fixed   [
		  ['width | 'height]        (put shape-opts 'fixed   s/2)
	      | 'off                    (put shape-opts 'fixed   false)
	    |                           (put shape-opts 'fixed   true)
		]
	  | 'growing [
		    ['width | 'height]      (put shape-opts 'growing s/2)
		  | 'off                    (put shape-opts 'growing false)
		  |                         (put shape-opts 'growing true)
		]
	  | 'tight   [
		    ['width | 'height]      (put shape-opts 'tight   s/2)
		  | 'off                    (put shape-opts 'tight   false)
		  |                         (put shape-opts 'tight   true)
		]
	  | 'max     [                  ;Limit max size of this element
		  'width  integer!          (put shape-opts 'max-width  s/3)
		| 'height integer!          (put shape-opts 'max-height s/3)
		| pair!                     (put shape-opts 'max-size   s/2)
		]
	  | 'min     [                  ;Limit min size of this element
		  'width  integer!          (put shape-opts 'min-width  s/3)
		| 'height integer!          (put shape-opts 'min-height s/3)
		| pair!                     (put shape-opts 'min-size   s/2)
		]
	  | 'stretch                    (stretch?: true)  ;stretch shape to match longer/wider neighbour
	  | 'unstretch                  (stretch?: false)
	]
	
	style-options: [
	    float!  (put style-opts 'line-width s/1)
	  | color   (put style-opts 'fill-pen   clr)
	  | ['pen | 'fill-pen] color 
		        (put style-opts  s/1        clr)
	  | ['line-cap | 'line-join]
		        (put style-opts  s/1        s/2)
	]
	
	text-options: [
	  if (not label-text) set label-text string! any [a: 
	      opt 'align a: labels-align 
	                           (put text-opts 'align   a/1)
	      | 'padding [integer! | pair!] 
			                   (put text-opts 'padding a/2)
	      | ['outside | 'inside | 'on-border] 
		                       (put text-opts 'side    a/1)
		  | 'as shapes		   (put text-opts 'shape   a/2)
		]
	  | ['outside | 'inside]   (put text-opts 'side    s/1)
	  | 'adjust  pair!         (put text-opts 'adjust  s/2)
	]
	
	font-options: [
	    'font    [
		    color           (put font-opts quote color: clr)
	      | 'anti-alias ['off | 'on]
			                (put font-opts quote anti-alias: s/3)
	      | ['bold | 'italic | 'underline] 
			                (put font-opts quote style: to-lit-word s/2)
	      | integer!        (put font-opts quote size: s/2)
	      | string!         (put font-opts quote name: s/2)
	      | [word! | path!] (put font-opts 'font s/2)
	      | block!          (put font-opts 'spec s/2)
	    ]
	|	['bold | 'italic | 'underline] 
			                (put font-opts quote style: to-lit-word s/1)
	]

	sub-options: [
		'sub opt [
			'grid pair! (put shape-opts 'grid s/3)
			opt ['show (
				repend style-opts [
					'fill-pen 'pattern s/3 reduce [
						'fill-pen clr 'pen 'off 'line-width 0.5
						'box  0x0 as-pair s/3/x s/3/y
						'pen silver 
						'line 0x0 as-pair s/3/x 0
						'line 0x0 as-pair 0 s/3/y 
					]
				]
			)]
		]
		ahead block! ;e: 
		    (start-layout) into rule (
			;probe reduce ["start" lofs "gpos" gpos "gofs" gofs "gsz" gsz "lgpos" lgpos "lgsz" lgsz] 
			end-layout 
			;probe reduce ["end" lofs "gpos" gpos "gofs" gofs "gsz" gsz "lgpos" lgpos "lgsz" lgsz]
			)
	]
	
	;; EDGE ;;
	edge-type:  [
	    'line
	  | 'ortho
	  | 'spline
	  | 'sline
	  | 'arc
	  | 'straight
	  
	  | 'curv
	  | 'curve
	]
	
	edge-def: [s:
	    float!  (put cstyle-opts 'line-width s/1)
	  | color   (put cstyle-opts 'fill-pen   clr) ;Needed for e.g. fat-arrow
	  | ['pen | 'fill-pen] color 
		        (put cstyle-opts  s/1        clr)
	  | ['line-cap | 'line-join] skip
		        (put cstyle-opts  s/1        s/2)
	  | 'arrow (put cshape-opts 'arrow copy []) any [[
		    'tail      (append cshape-opts 'arrow 'tail)
		  | 'both      (append cshape-opts 'arrow 'both)
		  | opt 'head  (append cshape-opts 'arrow 'head)
		] opt [c: shape (append chape-opts 'arrow c/1)] ];any format]
	  | 'from [set from-dir directions collect into cpath keep pick any [integer! | pair!] 
		  | set from* word! opt [
			   set from-dir directions collect into cpath keep pick any [integer! | pair!] 
		  ]
		]
	  | 'to   [set to-dir   directions | set to*   word! opt [set to-dir directions]]
	]
	
	directions: [
		'N | 'S | 'E | 'W | 'C
	  | 'NE | 'SE | 'NW | 'SW 
	  | 'NNE | 'ENE | 'ESE | 'SSE | 'SSW | 'WSW | 'WNW | 'NNW
	  | path!  ;Can describe a path of points or alteration of a point (e.g. N/E = Nord ten East = 1/3 between N and NNE)
	]
	
	arrow-def: [
		set arrow-shape shapes
	]
	
	connection: [[
		;By default, connectors are added automatically if 'connected is determined, and 'connect will modify the default connector.
		;Single 'connect determines single connector, by default from main side of previous shape to main side of next shape.
		;'connects are gathered into group to be added after next shape (if any) is positioned
	    'connect      (connect?: yes init-cshape label-text: none init-from-to) 
		  opt [c: edge-type (put cshape-opts 'ctype c/1)]
		  any edge-def (if all [from* to*][add-connection connect?: no])
	  | 'disconnect   (connect?: no)  ;disconnects single shape in scope of 'connected
	  | 'connected    (connected?: yes) opt [opt 'by set ctype edge-type ];any edge-def] ;sets start of connected shapes (next shape is first to be connected) 
	  | 'disconnected (connected?: connect?: no) ;ends scope of connected shapes (should next be last connected?)
	  ] ;opt [edge-type any edge-def]
	]
	
	;; MAIN RULE ;;
	rule: [
		any layout-options (bk: gbk)
		any [p: 
		    'set any layout-options
		  | layout-directive
		  | style-definition
		  | set ref set-word!
		  | set type shape-type shape-def
		  | set label-text string! (type: shape init-shape) shape-def
		  | connection
		  | 'draw s: block! (append/only gbk compose/deep s/1)
		  | s: (cause-error 'user 'message rejoin [
				"Can't interpret spec at: " copy/part s 5
			])
		]
	]

	;Entry point
	process: function [face spec [block!] /extern p][
		init
		parse spec rule
		add-gbk
		ofs: lpos - lofs
		;probe reduce ["ofs" ofs "lpos" lpos "lofs" lofs]
		if origin [ofs: ofs + origin]
		;probe reduce ["Final references:" references] 
		;probe reduce ["from*" from* "pos" references/:from* "from-dir" from-dir "to*" to* "pos" references/:to* "to-dir" to-dir]	
		probe 
		reduce ['translate ofs lbk]
	]
	
]