{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.0.9";
  sha256 = "1kfydlvmx4pgi5lpbhqr4p3jr78p3f61ic32046mkp4yfyydrspl";
})
