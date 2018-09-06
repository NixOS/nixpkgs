{ stdenv, callPackage, fetchurl, gambit }:

callPackage ./build.nix {
  version = "0.13";
  git-version = "0.13";
  GAMBIT = gambit;
  SRC = fetchurl {
    url = "https://github.com/vyzo/gerbil/archive/v0.13.tar.gz";
    sha256 = "1qs0vdq2lgxlpw20s8jzw2adx1xk9wb3w2m4a8vp6bb8hagmfr5l";
  };
  inherit stdenv;
}
