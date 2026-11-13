.PHONY: all
all: SwiftToCxxInteropTest

SwiftStruct.o Check-SwiftStruct.h: Sources/SwiftStruct.swift
	swiftc -parse-as-library -emit-clang-header-path Check-SwiftStruct.h -module-name Check -cxx-interoperability-mode=default $^ -c -o SwiftStruct.o

main.o: main.cpp Check-SwiftStruct.h
	clang++ $< -c -o $@

SwiftToCxxInteropTest: main.o SwiftStruct.o
	swiftc $^ -o $@
