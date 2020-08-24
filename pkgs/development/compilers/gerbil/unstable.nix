{ callPackage, fetchFromGitHub, gambit-unstable, gambit-support }:

callPackage ./build.nix rec {
  version = "unstable-2020-11-05";
  git-version = "0.16-152-g808929ae";
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "808929aeb8823959191f35df53bc0c0150911b4b";
    sha256 = "0d9k2gkrs9qvlnk7xa3gjzs3gln3ydds7yd2313pvbw4q2lcz8iw";
  };
  inherit gambit-support;
  gambit = gambit-unstable;
  gambit-params = gambit-support.unstable-params;
}
