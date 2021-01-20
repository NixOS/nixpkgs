{ self, callPackage }:
callPackage ./default.nix {
  inherit self;
  version = "2.1.0-2020-12-28";
  rev = "65378759f38bb946e40f31799992434effd01bba";
  isStable = false;
  sha256 = "1h78gydlrmvkdrql4ra5a3xr78iiq12bfmny6kiq65v1jbk8f19g";
}
