{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.5";
  branch = "2.7";
  sha256 = "1kl0dhlbl10ry0hk633vw321g12ysr7d0j79jh4xi4znxnf3mzl7";
})
