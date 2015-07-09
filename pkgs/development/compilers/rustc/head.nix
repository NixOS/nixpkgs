{ stdenv, callPackage }:
callPackage ./generic.nix {
  shortVersion = "2015-07-01";
  isRelease = false;
  # src rev for master on 2015-07-01
  srcRev = "bf3c979ec";
  srcSha = "1xp2fjffz5bwxfs37w80bdhy9lv091ps7xbnsvxid2i91rbxfrkk";
  snapshotHashLinux686 = "a6f22e481eabf098cc65bda97bf7e434a1fcc20b";
  snapshotHashLinux64 = "5fd8698fdfe953e6c4d86cf4fa1d5f3a0053248c";
  snapshotHashDarwin686 = "9a273324a6b63a40f67a553029c0a9fb692ffd1f";
  snapshotHashDarwin64 = "e5b12cb7c179fc98fa905a3c84803645d946a6ae";
  snapshotDate = "2015-05-24";
  snapshotRev = "ba0e1cd";
  patches = [
    ./patches/head.patch
  ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}

