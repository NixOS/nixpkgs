{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "30";
  sha256 = "09d1cvg6dnfi225wipc1fw691bq7xxdcmgkq8smldc5kivf3mbwd";
  openssl = null;
  postPatch = "sed '1i#include <cmath>' -i src/tests/test_bigint.cpp";
})
