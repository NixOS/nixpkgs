package main

import (
	// This stdlib package uses cgo with system frameworks on darwin
	_ "crypto/x509"
	"fmt"
)

func main() {
	fmt.Println("hello")
}
