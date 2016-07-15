{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "29";
  sha256 = "157bp8716h17agrxyj7xpsj2i5sqhafj1nfx4gpzccx7y2kyq176";
  openssl = null;
  postPatch = "sed '1i#include <cmath>' -i src/tests/test_bigint.cpp";
})
