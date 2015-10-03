{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "19";
  sha256 = "0a1hgd3w2pyn6yx89bal61bkxxazv0p8x8x4kri73p1b4vj3n3sb";
  openssl = null;
})
