{ lib
, stdenv
, fetchFromGitHub
, cmake
, meson
}:

stdenv.mkDerivation rec {
  pname = "xbyak";
  version = "6.69.1";

  src = fetchFromGitHub {
    owner = "herumi";
    repo = "xbyak";
    rev = "v${version}";
    hash = "sha256-yMArB0MmIvdqctr2bstKzREDvb7OnGXGMSCiGaQ3SmY=";
  };

  nativeBuildInputs = [
    cmake
    meson
  ];

  meta = with lib; {
    description = "A JIT assembler for x86(IA-32)/x64(AMD64, x86-64) MMX/SSE/SSE2/SSE3/SSSE3/SSE4/FPU/AVX/AVX2/AVX-512 by C++ header";
    homepage = "https://github.com/herumi/xbyak";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kranzes ];
  };
}
