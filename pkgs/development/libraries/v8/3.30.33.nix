{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.30.33.16";
  sha256 = "1azf1b36gqj4z5x0k9wq2dkp99zfyhwb0d6i2cl5fjm3k6js7l45";
})
