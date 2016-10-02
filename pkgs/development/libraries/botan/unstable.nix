{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "31";
  sha256 = "1vnx75g5zzzbgsrwnmnhqdal29gcn63g0ldyj0g9cky8ha8iqx8f";
  openssl = null;
  postPatch = "sed '1i#include <cmath>' -i src/tests/test_bigint.cpp";
})
