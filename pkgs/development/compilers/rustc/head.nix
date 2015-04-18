{ stdenv, callPackage }:
callPackage ./makeRustcDerivation.nix {
  shortVersion = "1.0.0-dev";
  isRelease = false;
  # src rev for master on 2015/03/09
  srcRev = "91bdf23f504f79ed59617cde3dfebd3d5e39a476";
  srcSha = "1s1v1q630d88idz331n4m0c3ninzipmvfzmkvdaqqm28wsn69xx7";
  snapshotHashLinux686 = "50a47ef247610fb089d2c4f24e4b641eb0ba4afb";
  snapshotHashLinux64 = "ccb20709b3c984f960ddde996451be8ce2268d7c";
  snapshotHashDarwin686 = "ad263bdeadcf9bf1889426e0c1391a7cf277364e";
  snapshotHashDarwin64 = "01c8275828042264206b7acd8e86dc719a2f27aa";
  snapshotDate = "2015-03-07";
  snapshotRev = "270a677";
  patches = [
    ./patches/head.patch
  ] ++ stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
}

