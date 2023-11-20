{ callPackage, fetchFromGitHub, gambit-support }:

callPackage ./build.nix rec {
  version = "unstable-2023-10-07";
  git-version = "4.9.5-59-g342399c7";
  stampYmd = 20231007;
  stampHms = 170745;
  rev = "342399c736ec560c0ff4faeaeb9599b45633f26c";
  src = fetchFromGitHub {
    owner = "gambit";
    repo = "gambit";
    inherit rev;
    sha256 = "121pj6lxihjjnfq33lq4m5hi461xbs9f41qd4l46556dr15cyf8f";
  };
  gambit-params = gambit-support.unstable-params;
}
