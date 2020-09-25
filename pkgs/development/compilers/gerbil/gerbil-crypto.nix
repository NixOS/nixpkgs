{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "gerbil-crypto";
  version = "unstable-2020-08-01";
  git-version = "0.0-6-ga228862";
  gerbil-package = "clan/crypto";
  gerbil = gerbil-unstable;
  gerbilInputs = [gerbil-support.gerbilPackages-unstable.gerbil-utils];
  buildInputs = [pkgs.secp256k1 pkgs.pkg-config];
  gambit-params = gambit-support.unstable-params;
  version-path = "version";
  softwareName = "Gerbil-crypto";
  src = fetchFromGitHub {
    owner = "fare";
    repo = "gerbil-crypto";
    rev = "a22886260849ec92c3a34bfeedc1574e41e49e33";
    sha256 = "0qbanw2vnw2ymmr4pr1jap29cyc3icbhyq0apibpfnj2znns7w47";
  };
  meta = {
    description = "Gerbil Crypto: Extra Cryptographic Primitives for Gerbil";
    homepage    = "https://github.com/fare/gerbil-crypto";
    license     = lib.licenses.asl20;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };
}
