{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.4";
  branch = "2.5";
  sha256 = "11m2hbhdgphjxjp6hk438cxmipqjg5ixbr1kqnn9mbdhq9kc34fc";
})
