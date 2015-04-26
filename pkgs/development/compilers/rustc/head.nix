{ stdenv, callPackage }:
callPackage ./makeRustcDerivation.nix {
  shortVersion = "1.0.0-dev";
  isRelease = false;
  # src rev for master on 2015/04/13
  srcRev = "0cf99c3e06e84d20d68da649c888d63c72f33971";
  srcSha = "0brnzsbxmidjnmvi36sz582k3kw6wk813y2y837zpmyxg9fjah0l";
  snapshotHashLinux686 = "1ef82402ed16f5a6d2f87a9a62eaa83170e249ec";
  snapshotHashLinux64 = "ef2154372e97a3cb687897d027fd51c8f2c5f349";
  snapshotHashDarwin686 = "0310b1a970f2da7e61770fd14dbbbdca3b518234";
  snapshotHashDarwin64 = "5f35d9c920b8083a7420ef8cf5b00d5ef3085dfa";
  snapshotDate = "2015-03-27";
  snapshotRev = "5520801";
  patches = [
    ./patches/head.patch
  ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}

