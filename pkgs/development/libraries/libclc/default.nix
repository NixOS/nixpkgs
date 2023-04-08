{ lib, stdenv, fetchFromGitHub, ninja, cmake, python3, llvmPackages, spirv-llvm-translator }:

let
  llvm = llvmPackages.llvm;
  clang-unwrapped = llvmPackages.clang-unwrapped;
in

stdenv.mkDerivation rec {
  pname = "libclc";
  version = "15.0.7";

  src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "llvmorg-${version}";
    sha256 = "sha256-wjuZQyXQ/jsmvy6y1aksCcEDXGBjuhpgngF3XQJ/T4s=";
  };
  sourceRoot = "source/libclc";

  # cmake expects all required binaries to be in the same place, so it will not be able to find clang without the patch
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'find_program( LLVM_CLANG clang PATHS ''${LLVM_BINDIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_CLANG clang PATHS "${clang-unwrapped}/bin" NO_DEFAULT_PATH )' \
      --replace 'find_program( LLVM_SPIRV llvm-spirv PATHS ''${LLVM_BINDIR} NO_DEFAULT_PATH )' \
                'find_program( LLVM_SPIRV llvm-spirv PATHS "${spirv-llvm-translator}/bin" NO_DEFAULT_PATH )'
  '';

  nativeBuildInputs = [ cmake ninja python3 spirv-llvm-translator ];
  buildInputs = [ llvm clang-unwrapped ];
  strictDeps = true;
  cmakeFlags = [
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "http://libclc.llvm.org/";
    description = "Implementation of the library requirements of the OpenCL C programming language";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
