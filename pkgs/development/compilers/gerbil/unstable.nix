{ stdenv, callPackage, fetchFromGitHub, gambit-unstable }:

callPackage ./build.nix {
  version = "unstable-2019-02-09";
  git-version = "0.16-DEV-15-gafc20fc2";
  gambit = gambit-unstable;
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "afc20fc21030e8445b46b8267cc4c52cfd662aad";
    sha256 = "02v16zya9zryjs4wallibp1kvnpba60aw15y4k7zhddc71qjfbhw";
  };
  inherit stdenv;
}
