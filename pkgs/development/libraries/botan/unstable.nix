{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "34";
  sha256 = "05hzffp0dxac7414a84z0fgv980cnfx55ch2y4vpg5nvin7m9bar";
  openssl = null;
  postPatch = "sed '1i#include <cmath>' -i src/tests/test_bigint.cpp";
})
