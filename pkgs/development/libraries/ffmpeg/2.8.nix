{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.8";
  branch = "2.8";
  sha256 = "19h6xmlcb933hgpfd40mjwkral8v389v25sx660a3p7aiyalh25p";
})
