{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.0.6";
  sha256 = "1qypc5lx82vlqm9016knxx8khxpc9dy78a0q2x5jmxjk8v6g994r";
})
