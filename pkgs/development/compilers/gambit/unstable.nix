{ callPackage, fetchFromGitHub, gambit-support }:

callPackage ./build.nix {
  version = "unstable-2023-08-06";
  git-version = "4.9.5-5-gf1fbe9aa";
  stampYmd = 20230806;
  stampHms = 195822;
  src = fetchFromGitHub {
    owner = "gambit";
    repo = "gambit";
    rev = "f1fbe9aa0f461e89f2a91bc050c1373ee6d66482";
    sha256 = "0b0gd6cwj8zxwcqglpsnmanysiq4mvma2mrgdfr6qy99avhbhzxm";
  };
  gambit-params = gambit-support.unstable-params;
}
