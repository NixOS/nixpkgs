{ stdenv, callPackage }:

callPackage ./generic.nix {
  shortVersion = "1.3.0";
  isRelease = true;
  configureFlags = [ "--release-channel=stable" ];
  srcSha = "14lhk40n9aslz8h8wj7fas5vsgyrb38b2r319q3hlvplgggdksg8";

  /* Rust is bootstrapped from an earlier built version. We need
  to fetch these earlier versions, which vary per platform.
  The shapshot info you want can be found at
  https://github.com/rust-lang/rust/blob/{$shortVersion}/src/snapshots.txt
  with the set you want at the top. Make sure this is the latest snapshot
  for the tagged release and not a snapshot in the current HEAD.
  */

  snapshotHashLinux686 = "3459275cdf3896f678e225843fa56f0d9fdbabe8";
  snapshotHashLinux64 = "e451e3bd6e5fcef71e41ae6f3da9fb1cf0e13a0c";
  snapshotHashDarwin686 = "428944a7984c0988e77909d82ca2ef77d96a1fbd";
  snapshotHashDarwin64 = "b0515bb7d2892b9a58282fc865fee11a885406d6";
  snapshotDate = "2015-07-26";
  snapshotRev = "a5c12f4";

  # cc-ar-opts.patch should be removable in 1.4.0+
  patches = [ ./patches/remove-uneeded-git.patch ./patches/cc-ar-opts.patch ]
    ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}
