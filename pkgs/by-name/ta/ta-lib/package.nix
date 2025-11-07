{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "ta-lib";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "rafa-dot-el";
    repo = "talib";
    rev = version;
    sha256 = "sha256-bIzN8f9ZiOLaVzGAXcZUHUh/v9z1U+zY+MnyjJr1lSw=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Add technical analysis to your own financial market trading applications";
    mainProgram = "ta-lib-config";
    homepage = "https://ta-lib.org/";
    license = lib.licenses.bsd3;

    platforms = platforms.linux;
    maintainers = with maintainers; [ rafael ];
  };
}
