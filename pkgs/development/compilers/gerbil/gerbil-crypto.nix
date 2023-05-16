<<<<<<< HEAD
{ pkgs, lib, fetchFromGitHub, gerbilPackages, ... }:

{
  pname = "gerbil-crypto";
  version = "unstable-2023-03-27";
  git-version = "0.0-18-ge57f887";
  gerbil-package = "clan/crypto";
  gerbilInputs = with gerbilPackages; [ gerbil-utils gerbil-poo ];
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.secp256k1 ];
  version-path = "version";
  softwareName = "Gerbil-crypto";

  pre-src = {
    fun = fetchFromGitHub;
    owner = "fare";
    repo = "gerbil-crypto";
    rev = "e57f88742d9b41640b4a7d9bd3e86c688d4a83f9";
    sha256 = "08hrk3s82hbigvza75vgx9kc7qf64yhhn3xm5calc859sy6ai4ka";
  };

  meta = with lib; {
    description = "Gerbil Crypto: Extra Cryptographic Primitives for Gerbil";
    homepage    = "https://github.com/fare/gerbil-crypto";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
=======
{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "gerbil-crypto";
  version = "unstable-2020-08-01";
  git-version = "0.0-6-ga228862";
  gerbil-package = "clan/crypto";
  gerbil = gerbil-unstable;
  gerbilInputs = [gerbil-support.gerbilPackages-unstable.gerbil-utils];
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [pkgs.secp256k1 ];
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
