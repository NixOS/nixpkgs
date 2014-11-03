{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.0.2";
  sha256 = "1ph4cb6nrk2hiy89j3kz1wj16ph0b9yixrf4f4935rnzhha8x31w";
})
