{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "5.5.22";
  sha256 = "b997e1dbe95704e0e806e0cedc5fd370a385351fef565c7bae0917baf3a29aa4";
})
