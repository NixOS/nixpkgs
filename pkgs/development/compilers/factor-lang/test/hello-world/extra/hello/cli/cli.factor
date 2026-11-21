! SPDX-License-Identifier: 0BSD
USING: command-line combinators io kernel namespaces sequences hello ;

IN: hello.cli

: main ( -- )
    command-line get {
        { [ dup empty? ] [ drop "world" ] }
        { [ dup first "--name" = not ] [ drop "world" ] }
        [ second ]
    } cond greet ;

MAIN: main
