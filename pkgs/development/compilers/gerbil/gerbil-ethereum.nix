{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:
{
  pname = "gerbil-ethereum";
  version = "unstable-2020-10-18";
  git-version = "0.0-26-gf27ada8";
  gerbil-package = "mukn/ethereum";
  gerbil = gerbil-unstable;
  gerbilInputs = with gerbil-support.gerbilPackages-unstable;
    [gerbil-utils gerbil-crypto gerbil-poo gerbil-persist];
  buildInputs = [];
  gambit-params = gambit-support.unstable-params;
  version-path = "version";
  softwareName = "Gerbil-ethereum";
  pre-src = {
    fun = fetchFromGitHub;
    owner = "fare";
    repo = "gerbil-ethereum";
    rev = "f27ada8e7f4de4f8fbdfede9fe055914b254d8e7";
    sha256 = "1lykjqim6a44whj1r8kkpiz68wghkfqx5vjlrc2ldxlmgd4r9gvd";
  };
  meta = {
    description = "Gerbil Ethereum: a Scheme alternative to web3.js";
    homepage    = "https://github.com/fare/gerbil-ethereum";
    license     = lib.licenses.asl20;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };
}
