{ stdenv, callPackage, rustcStable }:

callPackage ./generic.nix {
  shortVersion = "beta-1.10.0";
  forceBundledLLVM = false;
  configureFlags = [ "--release-channel=beta" ];
  srcRev = "39f3c16cca889ef3f1719d9177e3315258222a65";
  srcSha = "01bx6616lslp2mbj4h8bb6m042fs0y1z8g0jgpxvbk3fbhzwafrx";
  patches = [ ./patches/disable-lockfile-check.patch ] ++
    stdenv.lib.optional stdenv.needsPax ./patches/grsec.patch;
  rustc = rustcStable;
}
