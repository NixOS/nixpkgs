{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.2";
  branch = "1.5";
  sha256 = "11waq9w215zvzxrpv40afyd18qf79mxc28fda80bm3ax98cpppqm";
})
