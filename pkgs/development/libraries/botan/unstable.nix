{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "32";
  sha256 = "0b4wgqyv6accsdh7fgr9as34r38f8r9024i6s3vhah6wiah7kddn";
  openssl = null;
  postPatch = "sed '1i#include <cmath>' -i src/tests/test_bigint.cpp";
})
