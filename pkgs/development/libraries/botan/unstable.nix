{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.11";
  revision = "16";
  sha256 = "0z3a7jp10w9ipmbzhc2xazd2savxmns57ca2a8d6vvjahxg4w6m3";
  openssl = null;
})
