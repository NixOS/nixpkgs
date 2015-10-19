{ fetchgit }:
fetchgit {
  url = git://github.com/ghcjs/ghcjs-boot.git;
  rev = "39cd58e12f02fa99f493387ba4c3708819a72294";
  sha256 = "0s7hvg60piklrg9ypa7r44l4qzvpinrgsaffak6fr7gd3k08wn9d";
  fetchSubmodules = true;
}
