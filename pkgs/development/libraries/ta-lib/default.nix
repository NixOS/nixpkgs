{ lib, stdenv, fetchurl, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ta-lib";
  version = "0.4.0";
  src = fetchurl {
    url = "https://github.com/TA-Lib/ta-lib/releases/download/v0.4.0/ta-lib-0.4.0-src.tar.gz";
    hash = "sha256-n/Qe/LHAEaS0tt/JFhCwbjmx15c+1dTe5VApoKxNxlE=";
  };
  # src = fetchFromGitHub {
  #   owner = "TA-Lib";
  #   repo = "ta-lib";
  #   rev = "v${version}";
  #   sha256 = "sha256-wRpf3X8JWx+X2u0fCOivUSDCu03eZidYEBci8kibR54=";
  # };

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
