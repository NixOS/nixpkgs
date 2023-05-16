<<<<<<< HEAD
{ lib, fetchFromGitHub, ... }:

{
  pname = "smug-gerbil";
  version = "unstable-2020-12-12";
  git-version = "0.4.20";
  softwareName = "Smug-Gerbil";
  gerbil-package = "drewc/smug";

  pre-src = {
    fun = fetchFromGitHub;
    owner = "drewc";
    repo = "smug-gerbil";
    rev = "cf23a47d0891aa9e697719309d04dd25dd1d840b";
    sha256 = "13fdijd71m3fzp9fw9xp6ddgr38q1ly6wnr53salp725w6i4wqid";
  };

  meta = with lib; {
    description = "Super Monadic Über Go-into : Parsers and Gerbil Scheme";
    homepage    = "https://github.com/drewc/smug-gerbil";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ fare ];
  };
=======
{ pkgs, lib, fetchFromGitHub, gerbil-unstable, gerbil-support, gambit-support }:

gerbil-support.gerbilPackage {
  pname = "smug-gerbil";
  version = "unstable-2019-12-24";
  git-version = "95d60d4";
  gerbil-package = "drewc/smug";
  gerbil = gerbil-unstable;
  gerbilInputs = [];
  buildInputs = [];
  gambit-params = gambit-support.unstable-params;
  version-path = ""; #"version";
  softwareName = "Smug-Gerbil";
  src = fetchFromGitHub {
    owner = "drewc";
    repo = "smug-gerbil";
    rev = "95d60d486c1603743c6d3c525e6d5f5761b984e5";
    sha256 = "0ys07z78gq60z833si2j7xa1scqvbljlx1zb32vdf32f1b27c04j";
  };
  meta = {
    description = "Super Monadic Über Go-into : Parsers and Gerbil Scheme";
    homepage    = "https://github.com/drewc/smug-gerbil";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fare ];
  };
  buildScript = ''
    for i in primitive simple tokens smug ; do gxc -O $i.ss ; done
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
