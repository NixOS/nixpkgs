{ callPackage, ... } @ args:

callPackage ./generic.nix (rec {
  version = "${branch}.17";
  branch = "2.8";
  sha256 = "05bnhvs2f82aq95z1wd3wr42sljdfq4kiyzqwhpji983mndx14vl";
  knownVulnerabilities = [
    "CVE-2021-30123"
  ];
} // args)
