{ stdenv, callPackage, fetchgit, gambit-unstable }:

callPackage ./build.nix {
  version = "unstable-2018-09-06";
  git-version = "0.14-DEV";
  GAMBIT = gambit-unstable;
  SRC = fetchgit {
    url = "https://github.com/vyzo/gerbil.git";
    rev = "184cb635c82517d5d75d7966dcdf1d25ad863dac";
    sha256 = "1ljzbpc36i9zpzfwra5hpfbgzj1dyzzp50h5jf976n8qr9x4l7an";
  };
  inherit stdenv;
}
