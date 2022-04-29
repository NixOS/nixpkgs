package main

import (
	"fmt"

	_ "github.com/blakesmith/ar"
	_ "github.com/google/shlex"
	_ "github.com/marcinbor85/gohex"
	_ "go.bug.st/serial"
	_ "golang.org/x/tools/go/ast/astutil"
	_ "golang.org/x/tools/go/ssa"
	_ "google.golang.org/appengine"
	_ "tinygo.org/x/go-llvm"
)

func main() {
	fmt.Println("vim-go")
}
