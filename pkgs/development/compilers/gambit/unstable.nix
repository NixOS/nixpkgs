{ callPackage, fetchgit }:

callPackage ./build.nix {
  version = "unstable-2018-05-30";
  git-version = "4.8.9-54-gffe8841b";
  SRC = fetchgit {
    url = "https://github.com/feeley/gambit.git";
    rev = "ffe8841b56330eb86fd794b16dc7f83914ecc7c5";
    sha256 = "1xzkwa2f6zazybbgd5zynhr36krayhr29vsbras5ld63hkrxrp7q";
  };
}
