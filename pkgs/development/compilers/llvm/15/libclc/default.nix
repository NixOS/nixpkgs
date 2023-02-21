{ lib
, stdenv
, llvm_meta
, monorepoSrc
, runCommand
, cmake
, ninja
, python3
, llvm
, targetLlvm
, clang-unwrapped
, spirv-llvm-translator
, version
} @ args:

let
  llvm = if stdenv.buildPlatform == stdenv.hostPlatform then args.llvm else targetLlvm;
  spirv = spirv-llvm-translator.override {
    llvm = args.llvm; # use LLVM for the build platform here, not targetLlvm
  };
in

stdenv.mkDerivation rec {
  pname = "libclc";
  inherit version;

  src = runCommand "${pname}-src-${version}" {} ''
    cp -r ${monorepoSrc}/${pname} "$out"
  '';

  # cmake expects all required binaries to be in the same place, so it will not be able to find clang without the patch
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'find_program( LLVM_CLANG clang PATHS ''${LLVM_BINDIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_CLANG clang PATHS "${clang-unwrapped}/bin" NO_DEFAULT_PATH )' \
      --replace 'find_program( LLVM_SPIRV llvm-spirv PATHS ''${LLVM_BINDIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_SPIRV llvm-spirv PATHS "${spirv}/bin" NO_DEFAULT_PATH )'
  '';

  nativeBuildInputs = [ cmake ninja python3 spirv ];
  buildInputs = [ llvm clang-unwrapped ];
  strictDeps = true;
  cmakeFlags = [
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    # the libclc build uses the `clang` we pass in to build OpenCL C files but
    # we don't want it to use this `clang` for building C/C++ files
    #
    # usually the `cmake` setup hook passes in `-DCMAKE_CXX_COMPILER=$CXX` where
    # `$CXX` is the name of the compiler (i.e. `g++`, `clang++`, etc); in cases
    # where the stdenv is `clang` based this causes `cmake` to search `$PATH`
    # for `clang++` and to find our unwrapped `clang` instead of the stdenv's
    #
    # so, we explicitly tell CMake to use the C/C++ compiler from the stdenv:
    "-DCMAKE_C_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "-DCMAKE_CXX_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++"
  ];

  meta = llvm_meta // {
    homepage = "http://libclc.llvm.org/";
    description = "Implementation of the library requirements of the OpenCL C programming language";
  };
}
