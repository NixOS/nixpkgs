{ self, callPackage }:
callPackage ./default.nix {
  inherit self;
  version = "2.1.0-2020-03-20";
  rev = "9143e86";
  isStable = false;
  sha256 = "1zw1yr0375d6jr5x20zvkvk76hkaqamjynbswpl604w6r6id070b";
}
