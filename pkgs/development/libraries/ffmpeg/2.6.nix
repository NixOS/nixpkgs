{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.7";
  branch = "2.6";
  sha256 = "1f9bg6c2yd4b1vfh7qg6fq8dhvyy7824xfnz7gm7ir0l7nbs0017";
})
