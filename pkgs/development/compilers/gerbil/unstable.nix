{ callPackage, fetchFromGitHub, gambit-unstable, gambit-support }:

callPackage ./build.nix rec {
  version = "unstable-2020-08-02";
  git-version = "0.16-120-g3f248e13";
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "3f248e139dfa11be74284fc812253fbecafbaf31";
    sha256 = "18v192cypj0nbmfcyflm8qnwp27qwy65m0a19ggs47wwbzhgvgqh";
  };
  inherit gambit-support;
  gambit = gambit-unstable;
  gambit-params = gambit-support.unstable-params;
}
