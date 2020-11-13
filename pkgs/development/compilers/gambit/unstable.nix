{ callPackage, fetchFromGitHub, gambit-support }:

callPackage ./build.nix {
  version = "unstable-2021-06-16";
  git-version = "4.9.3-1447-gc0753ff1";
  stampYmd = 20210616;
  stampHms = 032740;
  src = fetchFromGitHub {
    owner = "feeley";
    repo = "gambit";
    rev = "c0753ff127baefebd00193a135f48f18c59c496a";
    sha256 = "0d46hdmw6v7pvvq5am73dngrw3v5f2dinxdkca4n7995v8hlvjpj";
  };
  gambit-params = gambit-support.unstable-params;
}
