{ stdenv, callPackage, fetchgit }:

callPackage ./build.nix {
  version = "unstable-2018-09-03";
# git-version = "4.9.0";
  SRC = fetchgit {
    url = "https://github.com/feeley/gambit.git";
    rev = "7cdc7e7b9194b2c088c0667efaf7686a4ffd0d8a";
    sha256 = "06mmi8jkinihfirz4gjfw2lhxhskiqf3d47sihzx10r60asyqcxg";
  };
  inherit stdenv;
}
