! SPDX-License-Identifier: 0BSD
USING: command-line combinators io kernel namespaces sequences ;

IN: hello

: greet ( name -- )
    "Hello, " prepend print ;

: main ( -- )
    command-line get {
        { [ dup empty? ] [ drop "world" ] }
        { [ dup first "--name" = not ] [ drop "world" ] }
        [ second ]
    } cond greet ;

MAIN: main
