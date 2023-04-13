{ lib, stdenv, fetchFromGitHub, pkg-config }:

stdenv.mkDerivation rec {
  version = "2.11.6";
  pname = "coinutils";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "CoinUtils";
    rev = "releases/${version}";
    hash = "sha256-avXp7eKSZ/Fe1QmSJiNDMnPQ70LlOHrBeUYb9lhka8c=";
  };

  doCheck = true;

  meta = with lib; {
    license = licenses.epl20;
    homepage = "https://github.com/coin-or/CoinUtils";
    description = "Collection of classes and helper functions that are generally useful to multiple COIN-OR projects";
    maintainers = with maintainers; [ tmarkus ];
  };
}
