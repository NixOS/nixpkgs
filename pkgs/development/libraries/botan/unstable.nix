{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "15";
  sha256 = "1rkv84v09llbxyvh33szi7zsjm19l02j7h60n9g7jhhc2w667jk0";
  openssl = null;
})
