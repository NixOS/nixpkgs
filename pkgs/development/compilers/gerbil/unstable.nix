{ stdenv, callPackage, fetchgit, gambit-unstable }:

callPackage ./build.nix {
  version = "unstable-2018-08-11";
  git-version = "0.13-DEV-542-g274e1a22";
  GAMBIT = gambit-unstable;
  SRC = fetchgit {
    url = "https://github.com/vyzo/gerbil.git";
    rev = "274e1a22b2d2b708d5582594274ab52ee9ba1686";
    sha256 = "10j44ar4xfl8xmh276zg1ykd3r0vy7w2f2cg4p8slwnk9r251g2s";
  };
  inherit stdenv;
}
