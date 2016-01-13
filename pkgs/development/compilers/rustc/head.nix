# Please make sure to check if rustfmt still builds when updating nightly
{ stdenv, callPackage }:

callPackage ./generic.nix {
  shortVersion = "2016-01-10";
  isRelease = false;
  forceBundledLLVM = false;
  srcRev = "d70ab2bdf16c22b9f3ff0230089b44855e3f1593";
  srcSha = "13ssis1bdgg8sdkgrvxcbd1qcfmf7q6bv4akfxrjgdm44l1n1l97";

  /* Rust is bootstrapped from an earlier built version. We need
  to fetch these earlier versions, which vary per platform.
  The shapshot info you want can be found at
  https://github.com/rust-lang/rust/blob/{$shortVersion}/src/snapshots.txt
  with the set you want at the top.
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

