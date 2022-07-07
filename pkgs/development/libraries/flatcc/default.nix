{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "flatcc";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "dvidelabs";
    repo = "flatcc";
    rev = "v${version}";
    sha256 = "sha256-0/IZ7eX6b4PTnlSSdoOH0FsORGK9hrLr1zlr/IHsJFQ=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DFLATCC_INSTALL=on"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=misleading-indentation"
    "-Wno-error=stringop-overflow"
  ];

  meta = {
    description = "FlatBuffers Compiler and Library in C for C ";
    homepage = "https://github.com/dvidelabs/flatcc";
    license = [ lib.licenses.asl20 ];
  };
}
