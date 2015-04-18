{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "0.16.17";
  sha256 = "1w5gcizd6jlvzwgy0307az856h0cly685yf275p1v6bdcafd58b7";
})
