{ stdenv, callPackage }:
callPackage ./generic.nix {
  shortVersion = "2015-07-28";
  isRelease = false;
  # src rev for 2015-07-28's nightly channel
  srcRev = "8b835572b";
  srcSha = "1qrw0vszr1zipsbp7gcm8kik73d2bfxwv6mniv81ygn9i7v76wfz";
  snapshotHashLinux686 = "93f6216a35d3bed3cedf244c9aff4cd716336bd9";
  snapshotHashLinux64 = "d8f4967fc71a153c925faecf95a7feadf7e463a4";
  snapshotHashDarwin686 = "29852c4d4b5a851f16d627856a279cae5bf9bd01";
  snapshotHashDarwin64 = "1a20259899321062a0325edb1d22990f05d18708";
  snapshotDate = "2015-07-17";
  snapshotRev = "d4432b3";
  patches = [
    ./patches/head.patch
  ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}

