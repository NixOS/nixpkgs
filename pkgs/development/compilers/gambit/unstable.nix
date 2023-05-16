{ callPackage, fetchFromGitHub, gambit-support }:

callPackage ./build.nix {
<<<<<<< HEAD
  version = "unstable-2023-08-06";
  git-version = "4.9.5-5-gf1fbe9aa";
  stampYmd = 20230806;
  stampHms = 195822;
  src = fetchFromGitHub {
    owner = "gambit";
    repo = "gambit";
    rev = "f1fbe9aa0f461e89f2a91bc050c1373ee6d66482";
    sha256 = "0b0gd6cwj8zxwcqglpsnmanysiq4mvma2mrgdfr6qy99avhbhzxm";
=======
  version = "unstable-2020-09-20";
  git-version = "4.9.3-1234-g6acd87df";
  src = fetchFromGitHub {
    owner = "feeley";
    repo = "gambit";
    rev = "6acd87dfa95bfca33082a431e72f023345dc07ee";
    sha256 = "0a3dy4ij8hzlp3sjam4b6dp6yvyz5d7g2x784qm3gp89fi2ck56r";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  gambit-params = gambit-support.unstable-params;
}
