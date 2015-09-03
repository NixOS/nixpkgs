{ stdenv, callPackage }:
callPackage ./generic.nix {
  shortVersion = "2015-08-09";
  isRelease = false;
  # src rev for 2015-08-09's nightly channel
  srcRev = "a5d33d891";
  srcSha = "1iivzk9ggjh7y89rbw275apw4rfmzh4jk50kf0milljhvf72660n";
  snapshotHashLinux686 = "3459275cdf3896f678e225843fa56f0d9fdbabe8";
  snapshotHashLinux64 = "e451e3bd6e5fcef71e41ae6f3da9fb1cf0e13a0c";
  snapshotHashDarwin686 = "428944a7984c0988e77909d82ca2ef77d96a1fbd";
  snapshotHashDarwin64 = "b0515bb7d2892b9a58282fc865fee11a885406d6";
  snapshotDate = "2015-07-26";
  snapshotRev = "a5c12f4";
  patches = [
    ./patches/head.patch
  ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}

