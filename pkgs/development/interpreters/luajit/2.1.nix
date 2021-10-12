{ self, callPackage }:
callPackage ./default.nix {
  inherit self;
  version = "2.1.0-2021-08-12";
  rev = "8ff09d9f5ad5b037926be2a50dc32b681c5e7597";
  isStable = false;
  sha256 = "18wp8sgmiwlslnvgs35cy35ji2igksyfm3f8hrx07hqmsq2d77vr";
}
