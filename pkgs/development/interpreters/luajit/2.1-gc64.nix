{ self, callPackage }:
callPackage ./default.nix {
  inherit self;
  version = "2.1.0-beta3";
  name = "2.1.0-beta3-gc64";
  isStable = false;
  sha256 = "1hyrhpkwjqsv54hnnx4cl8vk44h9d6c9w0fz1jfjz00w255y7lhs";
  withGC64 = true;
}
