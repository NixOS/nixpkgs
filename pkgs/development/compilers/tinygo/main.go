package main

import (
	"fmt"

	_ "github.com/aykevl/go-wasm"
	_ "github.com/blakesmith/ar"
	_ "github.com/gofrs/flock"
	_ "github.com/google/shlex"
	_ "github.com/marcinbor85/gohex"
	_ "github.com/mattn/go-colorable"
	_ "go.bug.st/serial"
	_ "go.bug.st/serial/enumerator"
	_ "golang.org/x/tools/go/ast/astutil"
	_ "golang.org/x/tools/go/ssa"
	_ "google.golang.org/appengine"
	_ "tinygo.org/x/go-llvm"
)

func main() {
	fmt.Println("vim-go")
}
