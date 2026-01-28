{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "ta-lib";
  version = "0.6.2";
  src = fetchFromGitHub {
    owner = "TA-Lib";
    repo = "ta-lib";
    rev = "v${version}";
    sha256 = "sha256-asTNJIdIq2pxQ0Lz+rbyDVBpghlsQqqvPy1HFi8BbN0=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  hardeningDisable = [ "format" ];

  meta = {
    description = "Add technical analysis to your own financial market trading applications";
    mainProgram = "ta-lib-config";
    homepage = "https://ta-lib.org/";
    license = lib.licenses.bsd3;

    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ rafael ];
  };
}
