{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ta-lib";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "TA-Lib";
    repo = "ta-lib";
    rev = version;
    sha256 = "";
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
