{ self, callPackage }:
callPackage ./default.nix {
  inherit self;
  version = "2.1.0-2021-06-25";
  rev = "e957737650e060d5bf1c2909b741cc3dffe073ac";
  isStable = false;
  sha256 = "04i7n5xdd1nci4mv2p6bv71fq5b1nkswz12hcgirsxqbnkrlbbcj";
}
