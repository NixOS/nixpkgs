{ lib, stdenv, fetchFromGitHub, ninja, cmake, python3, llvmPackages }:

let
  llvm = llvmPackages.llvm;
  clang-unwrapped = llvmPackages.clang-unwrapped;
in

stdenv.mkDerivation rec {
  pname = "libclc";
  version = "11.0.1";

  src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "llvmorg-${version}";
    sha256 = "0bxh43hp1vl4axl3s9n2nb2ii8x1cbq98xz9c996f8rl5jy84ags";
  };
  sourceRoot = "source/libclc";

  # cmake expects all required binaries to be in the same place, so it will not be able to find clang without the patch
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'find_program( LLVM_CLANG clang PATHS ''${LLVM_BINDIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_CLANG clang PATHS "${clang-unwrapped}/bin" NO_DEFAULT_PATH )'
  '';

  nativeBuildInputs = [ cmake ninja python3 ];
  buildInputs = [ llvm clang-unwrapped ];
  strictDeps = true;
  cmakeFlags = [
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  meta = with lib; {
    homepage = "http://libclc.llvm.org/";
    description = "Implementation of the library requirements of the OpenCL C programming language";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
