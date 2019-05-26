{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.14";
  branch = "2.8";
  sha256 = "1g6x3lyjl1zlfksizj1ys61kj97yg0xf4dlr6sr5acpbja3a26yn";
})
