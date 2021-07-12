{ callPackage, fetchFromGitHub, gambit-unstable, gambit-support }:

callPackage ./build.nix rec {
  version = "unstable-2021-03-18";
  git-version = "0.16-178-g17fbcb95";
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "17fbcb95a8302c0de3f88380be1a3eb6fe891b95";
    sha256 = "1k6zm93gfrlqxqlhljs5dxy8innrckm702lrvryi5mj9rjjf8162";
  };
  inherit gambit-support;
  gambit = gambit-unstable;
  gambit-params = gambit-support.unstable-params;
}
