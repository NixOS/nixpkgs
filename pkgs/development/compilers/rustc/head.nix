
{ stdenv, callPackage }:
callPackage ./generic.nix {
  shortVersion = "nightly";
  isRelease = false;
  srcRev = "98a59cf57e02b6e6a5a3bd74eb47b1422eaacc53";
  srcSha = "438ffcaed142d8f849106df7083aa590c84a49174f7cd79979d8a8442d6c776a";
  snapshotHashLinux686 = "a09c4a4036151d0cb28e265101669731600e01f2";
  snapshotHashLinux64 = "97e2a5eb8904962df8596e95d6e5d9b574d73bf4";
  snapshotHashDarwin686 = "ca52d2d3ba6497ed007705ee3401cf7efc136ca1";
  snapshotHashDarwin64 = "3c44ffa18f89567c2b81f8d695e711c86d81ffc7";
  snapshotDate = "2015-12-18";
  snapshotRev = "3391630";
  patches = [
    ./patches/head.patch
  ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}


