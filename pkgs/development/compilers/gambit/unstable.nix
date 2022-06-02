{ callPackage, fetchFromGitHub, gambit-support }:

callPackage ./build.nix {
  version = "unstable-2020-09-20";
  git-version = "4.9.3-1234-g6acd87df";
  src = fetchFromGitHub {
    owner = "feeley";
    repo = "gambit";
    rev = "6acd87dfa95bfca33082a431e72f023345dc07ee";
    sha256 = "0a3dy4ij8hzlp3sjam4b6dp6yvyz5d7g2x784qm3gp89fi2ck56r";
  };
  gambit-params = gambit-support.unstable-params;
}
