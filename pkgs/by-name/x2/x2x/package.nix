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
  version = "1.30-unstable-2025-02-17";

  src = fetchFromGitHub {
    owner = "dottedmag";
    repo = "x2x";
    rev = "08842516fa443a2cf799c6372f83466062f612c9";
    hash = "sha256-0ZVpG4ZrygrFZ0mVmNLWWdyqM43LtQPGwvZZPC92zuY=";
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
