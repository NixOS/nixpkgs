{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "gerbil-ethereum";
  version = "unstable-2020-08-02";
  git-version = "0.0-15-g7cd2dd7";
  gerbil-package = "mukn/ethereum";
  gerbil = gerbil-unstable;
  gerbilInputs = with gerbil-support.gerbilPackages-unstable;
    [gerbil-utils gerbil-crypto gerbil-poo gerbil-persist];
  buildInputs = [];
  gambit-params = gambit-support.unstable-params;
  version-path = "version";
  softwareName = "Gerbil-ethereum";
  src = fetchFromGitHub {
    owner = "fare";
    repo = "gerbil-ethereum";
    rev = "7cd2dd7436b11917d0729dbafe087cfa8ec38f86";
    sha256 = "0qq3ch2dg735yrj3l2c9pb9qlvz98x3vjfi2xyr4fwr78smpqgb5";
  };
  meta = {
    description = "Gerbil Ethereum: a Scheme alternative to web3.js";
    homepage    = "https://github.com/fare/gerbil-ethereum";
    license     = lib.licenses.asl20;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };
}
