{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "25";
  sha256 = "1spjryza9yznbsa26i1kg3hz4ifjdi6cjhfd2h2lqg07xyf2a66c";
  openssl = null;
})
