{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "13";
  sha256 = "1jg36k376w6d6g7hgs2d67sr84pail5qf6yy1s5ys7pc16k2dy41";
  openssl = null;
})
