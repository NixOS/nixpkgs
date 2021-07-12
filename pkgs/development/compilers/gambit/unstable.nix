{ callPackage, fetchFromGitHub, gambit-support }:

callPackage ./build.nix {
  version = "unstable-2021-05-03";
  git-version = "4.9.3-1389-g55b21ed9";
  src = fetchFromGitHub {
    owner = "feeley";
    repo = "gambit";
    rev = "55b21ed926e02fe0ddae204e6109b2261d849a2b";
    sha256 = "0ln3yyfnpf7f5xzwzzvlmpagdcbcxksb21z00ciry7x2afpxz6az";
  };
  gambit-params = gambit-support.unstable-params;
}
