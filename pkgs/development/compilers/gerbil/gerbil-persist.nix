<<<<<<< HEAD
{ lib, fetchFromGitHub, gerbilPackages, ... }:
{
  pname = "gerbil-persist";
  version = "unstable-2023-03-02";
  git-version = "0.1.0-24-ge2305f5";
  softwareName = "Gerbil-persist";
  gerbil-package = "clan/persist";
  version-path = "version";

  gerbilInputs = with gerbilPackages; [ gerbil-utils gerbil-crypto gerbil-poo ];

  pre-src = {
    fun = fetchFromGitHub;
    owner = "fare";
    repo = "gerbil-persist";
    rev = "e2305f53571e55292179286ca2d88e046ec6638b";
    sha256 = "1vsi4rfzpqg4hhn53d2r26iw715vzwz0hiai9r34z4diwzqixfgn";
  };

  meta = with lib; {
    description = "Gerbil Persist: Persistent data and activities";
    homepage    = "https://github.com/fare/gerbil-persist";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
=======
{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "gerbil-persist";
  version = "unstable-2020-08-31";
  git-version = "0.0-8-gd211390";
  gerbil-package = "clan/persist";
  gerbil = gerbil-unstable;
  gerbilInputs = with gerbil-support.gerbilPackages-unstable; [gerbil-utils gerbil-crypto gerbil-poo];
  buildInputs = [];
  gambit-params = gambit-support.unstable-params;
  version-path = "version";
  softwareName = "Gerbil-persist";
  src = fetchFromGitHub {
    owner = "fare";
    repo = "gerbil-persist";
    rev = "d211390c8a199cf2b8c7400cd98977524e960015";
    sha256 = "13s6ws8ziwalfp23nalss41qnz667z2712lr3y123sypm5n5axk7";
  };
  meta = {
    description = "Gerbil Persist: Persistent data and activities";
    homepage    = "https://github.com/fare/gerbil-persist";
    license     = lib.licenses.asl20;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
