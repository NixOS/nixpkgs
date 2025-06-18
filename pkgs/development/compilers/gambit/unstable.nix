{
  callPackage,
  fetchFromGitHub,
  gambit-support,
}:

callPackage ./build.nix rec {
  version = "unstable-2023-12-04";
  git-version = "4.9.5-84-g6b19d0c9";
  stampYmd = 20231204;
  stampHms = 204859;
  rev = "6b19d0c9084341306bbb7d6895321090a82988a0";
  src = fetchFromGitHub {
    owner = "gambit";
    repo = "gambit";
    inherit rev;
    sha256 = "0njcz9krak8nfyk3x6bc6m1rixzsjc1fyzhbz2g3aq5v8kz9mkl5";
  };
  gambit-params = gambit-support.unstable-params;
}
