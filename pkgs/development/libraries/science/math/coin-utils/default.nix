{ lib, stdenv, fetchFromGitHub, pkg-config }:

stdenv.mkDerivation rec {
  version = "2.11.8";
  pname = "coinutils";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "CoinUtils";
    rev = "releases/${version}";
    hash = "sha256-ZV2nLP/oOLfnBGk1yow+b/oTKpoxyEkcCPHCSNAk+Tk=";
  };

  doCheck = true;

  meta = with lib; {
    license = licenses.epl20;
    homepage = "https://github.com/coin-or/CoinUtils";
    description = "Collection of classes and helper functions that are generally useful to multiple COIN-OR projects";
    maintainers = with maintainers; [ tmarkus ];
  };
}
