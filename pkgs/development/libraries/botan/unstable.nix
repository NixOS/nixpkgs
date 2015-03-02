{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "10";
  sha256 = "06d5p0bs953r2pqfc635x2w78m3xv28gr6fmvd8whbk9qp8r91yb";
  openssl = null;
})
