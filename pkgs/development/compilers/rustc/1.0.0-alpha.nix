{ stdenv, callPackage }:
callPackage ./makeRustcDerivation.nix {
  shortVersion = "1.0.0-alpha";
  isRelease = true;
  srcSha = "0p62gx3s087n09d2v3l9iyfx5cmsa1x91n4ysixcb7w3drr8a8is";
  snapshotHashLinux686 = "d8b73fc9aa3ad72ce1408a41e35d78dba10eb4d4";
  snapshotHashLinux64 = "697880d3640e981bbbf23284363e8e9a158b588d";
  snapshotHashDarwin686 = "a73b1fc03e8cac747aab0aa186292bb4332a7a98";
  snapshotHashDarwin64 = "e4ae2670ea4ba5c2e5b4245409c9cab45c9eeb5b";
  snapshotDate = "2015-01-07";
  snapshotRev = "9e4e524";
  patches = [
    ./patches/hardcode_paths.alpha.patch
    ./patches/local_stage0.alpha.patch
    ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}

