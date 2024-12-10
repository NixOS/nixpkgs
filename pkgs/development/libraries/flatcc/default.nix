{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
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
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=misleading-indentation"
    "-Wno-error=stringop-overflow"
  ];

  meta = with lib; {
    description = "FlatBuffers Compiler and Library in C for C ";
    mainProgram = "flatcc";
    homepage = "https://github.com/dvidelabs/flatcc";
    license = [ licenses.asl20 ];
    maintainers = with maintainers; [ onny ];
  };
}
