# Please make sure to check if rustfmt still builds when updating nightly

{ stdenv, callPackage }:
callPackage ./generic.nix {
  shortVersion = "2015-09-05";
  isRelease = false;
  # src rev for 2015-09-05's nightly channel
  srcRev = "779b2a9847319106647dcad12fc6dc472bc0cf4d";
  srcSha = "0m22lxpcjnwa68bpxhfvp07k52gyds8ykif2pf5r2x22lw28vbg3";
  snapshotHashLinux686 = "e2553bf399cd134a08ef3511a0a6ab0d7a667216";
  snapshotHashLinux64 = "7df8ba9dec63ec77b857066109d4b6250f3d222f";
  snapshotHashDarwin686 = "29750870c82a0347f8b8b735a4e2e0da26f5098d";
  snapshotHashDarwin64 = "c9f2c588238b4c6998190c3abeb33fd6164099a2";
  snapshotDate = "2015-08-11";
  snapshotRev = "1af31d4";
  patches = stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}

