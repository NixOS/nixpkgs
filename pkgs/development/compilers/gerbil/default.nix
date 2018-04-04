{ callPackage, fetchurl, gambit }:

callPackage ./build.nix {
  version = "0.12-RELEASE";
  git-version = "0.12";
  GAMBIT = gambit;
  SRC = fetchurl {
    url = "https://github.com/vyzo/gerbil/archive/v0.12.tar.gz";
    sha256 = "0nigr3mgrzai57q2jqac8f39zj8rcmic3277ynyzlgm8hhps71pq";
  };
}
