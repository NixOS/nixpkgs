{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.15";
  branch = "0.5";
  sha256 = "1rcy15dv5bnpnncb78kgki9xl279bh99b76nzqdd87b61r04z74z";
})
