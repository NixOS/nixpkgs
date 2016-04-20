{ stdenv, callPackage }:

callPackage ./generic.nix {
  shortVersion = "1.8.0";
  isRelease = true;
  forceBundledLLVM = false;
  configureFlags = [ "--release-channel=stable" ];
  srcSha = "1s03aymmhhrndq29sv9cs8s4p1sg8qvq8ds6lyp6s4ny8nyvdpzy";

  /* Rust is bootstrapped from an earlier built version. We need
  to fetch these earlier versions, which vary per platform.
  The shapshot info you want can be found at
  https://github.com/rust-lang/rust/blob/{$shortVersion}/src/snapshots.txt
  with the set you want at the top. Make sure this is the latest snapshot
  for the tagged release and not a snapshot in the current HEAD.
  */

  snapshotHashLinux686 = "5f194aa7628c0703f0fd48adc4ec7f3cc64b98c7";
  snapshotHashLinux64 = "d29b7607d13d64078b6324aec82926fb493f59ba";
  snapshotHashDarwin686 = "4c8e42dd649e247f3576bf9dfa273327b4907f9c";
  snapshotHashDarwin64 = "411a41363f922d1d93fa62ff2fedf5c35e9cccb2";
  snapshotDate = "2016-02-17";
  snapshotRev = "4d3eebf";

  patches = [ ./patches/remove-uneeded-git.patch ]
    ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}
