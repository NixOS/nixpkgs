{ callPackage, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.3.0";
  branch = "2.3";
  revision = "v${version}";
  sha256 = "08plxrnfl33sn2vh5nwbsngyv6b1sfpplvx881crm1v1ai10m2lz";
})
