{
  lib,
  stdenv,
  libX11,
  libXtst,
  libXext,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libXi,
}:

stdenv.mkDerivation rec {
  pname = "x2x";
  version = "unstable-2023-04-30";

  src = fetchFromGitHub {
    owner = "dottedmag";
    repo = pname;
    rev = "53692798fa0e991e0dd67cdf8e8126158d543d08";
    hash = "sha256-FUl2z/Yz9uZlUu79LHdsXZ6hAwSlqwFV35N+GYDNvlQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libX11
    libXtst
    libXext
    libXi
  ];

  meta = with lib; {
    description = "Allows the keyboard, mouse on one X display to be used to control another X display";
    homepage = "https://github.com/dottedmag/x2x";
    license = licenses.bsd3;
    platforms = platforms.linux;
    mainProgram = "x2x";
  };
}
