{ stdenv, fetchurl, fetchpatch }:
import ./common.nix {
  inherit stdenv fetchurl;
  version = "5.0.1";
  sha256 = "4814781d395b0ef093b21a08e8e6e0bd3dab8762f9935bbfb71679b0dea7c3e9";
  patches = stdenv.lib.optional stdenv.isAarch64 (fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/jemalloc/jemalloc/pull/1035.patch";
    sha256 = "02y0q3dp253bipxv4r954nqipbjbj92p6ww9bx5bk3d8pa81wkqq";
  });
}
