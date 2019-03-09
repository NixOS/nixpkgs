{ self, callPackage, lib }:
callPackage ./default.nix {
  inherit self;
  version = "2.0.5";
  isStable = true;
  sha256 = "0yg9q4q6v028bgh85317ykc9whgxgysp76qzaqgq55y6jy11yjw7";
  extraMeta = {
    platforms = lib.filter (p: p != "aarch64-linux") lib.meta.platforms;
  };
}
