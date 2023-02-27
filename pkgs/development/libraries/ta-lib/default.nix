{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  name = "ta-lib";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "rafa-dot-el";
    repo = "talib";
    rev = "${version}";
    sha256 = "sha256-bIzN8f9ZiOLaVzGAXcZUHUh/v9z1U+zY+MnyjJr1lSw=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description =
      "TA-Lib is a library that provides common functions for the technical analysis of financial market data.";
    homepage = "https://ta-lib.org/";
    license = lib.licenses.bsd3;

    platforms = platforms.linux;
    maintainers = with maintainers; [ rafael ];
  };
}
