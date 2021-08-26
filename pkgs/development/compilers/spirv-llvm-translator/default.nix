{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config

, lit
, llvm_8
}:

stdenv.mkDerivation rec {
  pname = "SPIRV-LLVM-Translator";
  version = "8.0.1-2";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-LLVM-Translator";
    rev = "v${version}";
    sha256 = "0hxalc3fkliqs61hpr97phbm3qsx4b8vgnlg30aimzr6aas403r5";
  };

  nativeBuildInputs = [ pkg-config cmake llvm_8.dev ];

  buildInputs = [ llvm_8 ];

  checkInputs = [ lit ];

  cmakeFlags = [ "-DLLVM_INCLUDE_TESTS=ON" ];

  # FIXME: CMake tries to run "/llvm-lit" which of course doesn't exist
  doCheck = false;

  meta = with lib; {
    homepage    = "https://github.com/KhronosGroup/SPIRV-LLVM-Translator";
    description = "A tool and a library for bi-directional translation between SPIR-V and LLVM IR";
    license     = licenses.ncsa;
    platforms   = platforms.all;
    maintainers = with maintainers; [ gloaming ];
  };
}
