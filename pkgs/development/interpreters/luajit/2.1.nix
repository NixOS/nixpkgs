{ self, callPackage }:
callPackage ./default.nix {
  inherit self;
  version = "2.1.0-2021-10-27";
  rev = "b4b2dce9fc3ffaaaede39b36d06415311e2aa516";
  isStable = false;
  sha256 = "185s071aa0yffz8npgdxj7l98cs987vddb2l5pzfcdqfj41gn55q";
}
