{
  lib,
  stdenv,
  libx11,
  libxtst,
  libxext,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libxi,
}:

stdenv.mkDerivation {
  pname = "x2x";
  version = "unstable-2023-04-30";

  src = fetchFromGitHub {
    owner = "dottedmag";
    repo = "x2x";
    rev = "53692798fa0e991e0dd67cdf8e8126158d543d08";
    hash = "sha256-FUl2z/Yz9uZlUu79LHdsXZ6hAwSlqwFV35N+GYDNvlQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libx11
    libxtst
    libxext
    libxi
  ];

  meta = {
    description = "Allows the keyboard, mouse on one X display to be used to control another X display";
    homepage = "https://github.com/dottedmag/x2x";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "x2x";
  };
}
