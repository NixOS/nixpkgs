{ stdenv, callPackage }:

callPackage ./generic.nix {
  shortVersion = "1.7.0";
  isRelease = true;
  forceBundledLLVM = false;
  configureFlags = [ "--release-channel=stable" ];
  srcSha = "05f4v6sfmvkwsv6a7jp9sxsm84s0gdvqyf2wwdi1ilg9k8nxzgd4";

  /* Rust is bootstrapped from an earlier built version. We need
  to fetch these earlier versions, which vary per platform.
  The shapshot info you want can be found at
  https://github.com/rust-lang/rust/blob/{$shortVersion}/src/snapshots.txt
  with the set you want at the top. Make sure this is the latest snapshot
  for the tagged release and not a snapshot in the current HEAD.
  */

  snapshotHashLinux686 = "a09c4a4036151d0cb28e265101669731600e01f2";
  snapshotHashLinux64 = "97e2a5eb8904962df8596e95d6e5d9b574d73bf4";
  snapshotHashDarwin686 = "ca52d2d3ba6497ed007705ee3401cf7efc136ca1";
  snapshotHashDarwin64 = "3c44ffa18f89567c2b81f8d695e711c86d81ffc7";
  snapshotDate = "2015-12-18";
  snapshotRev = "3391630";

  patches = [ ./patches/remove-uneeded-git.patch ]
    ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}
