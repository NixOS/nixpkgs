{ stdenv, callPackage, fetchFromGitHub, gambit }:

callPackage ./build.nix rec {
  version = "0.14";
  git-version = "0.14";
  inherit gambit;
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "v${version}";
    sha256 = "0n078lkf8m391kr99ipb1v2dpi5vkikz9nj0p7kfjg43868my3v7";
  };
  inherit stdenv;
}
