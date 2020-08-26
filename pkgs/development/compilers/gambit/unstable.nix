{ callPackage, fetchFromGitHub, gambit-support }:

callPackage ./build.nix {
  version = "unstable-2020-07-29";
  git-version = "4.9.3-1232-gbba388b8";
  src = fetchFromGitHub {
    owner = "feeley";
    repo = "gambit";
    rev = "bba388b80ca62a77883a8936d64b03316808696a";
    sha256 = "0iqlp1mvxz8g32kqrqm0phnnp1i5c4jrapqh2wqwa8fh1vgnizg1";
  };
  gambit-params = gambit-support.unstable-params;
}
