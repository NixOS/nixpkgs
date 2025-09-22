{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  pcre,
  zlib,
  sqlite,
}:

stdenv.mkDerivation {
  pname = "falcon";
  version = "0-unstable-2023-11-19";

  src = fetchFromGitHub {
    owner = "falconpl";
    repo = "falcon";
    rev = "fc403c6e8c1f3d8c2a5a6ebce5db6f1b3e355808";
    hash = "sha256-0yLhwDVFNbfiW23hNxrvItCCkyaOvEbFSg1ZQuJvhIs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    pcre
    zlib
    sqlite
  ];

  meta = with lib; {
    description = "Programming language with macros and syntax at once";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
    broken = stdenv.cc.isClang;
  };
}
