{ lib
, llvmPackages
}:

{ ... }:

{ FFIGEN_COMPILER_OPTS ? ""
, ...
}:

{
  FFIGEN_LIBCLANG = lib.getLib llvmPackages.libclang;
  FFIGEN_COMPILER_OPTS = "-I${FFIGEN_COMPILER_OPTS} ${llvmPackages.clang}/resource-root/include -I${lib.makeSearchPathOutput "dev" "include" [ llvmPackages.clang.libc_dev ]}";
}
