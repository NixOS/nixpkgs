{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "14";
  sha256 = "1laa6d8w9v39a2pfmilj62jwc67r0jbq5f3xdlffd3kvkdnwcysb";
  openssl = null;
})
