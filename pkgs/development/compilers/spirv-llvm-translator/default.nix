{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, lit
, llvm_11
}:

stdenv.mkDerivation rec {
  pname = "SPIRV-LLVM-Translator";
  version = "unstable-2021-06-13";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-LLVM-Translator";
    rev = "c67e6f26a7285aa753598ef792593ac4a545adf9";
    sha256 = "sha256-1s3lVNTQDl+pUvbzSMsp3cOUSm6I4DzqJxnLMeeE3F4=";
  };

  nativeBuildInputs = [ pkg-config cmake llvm_11.dev ];

  buildInputs = [ llvm_11 ];

  checkInputs = [ lit ];

  cmakeFlags = [
    "-DLLVM_INCLUDE_TESTS=ON"
  ];

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
