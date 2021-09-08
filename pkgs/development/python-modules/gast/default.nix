self: rec {
  # Used by tensorflow 2.6.0
  gast_0_4 = self.callPackage ./common.nix {
    version = "0.4.0";
    sha256 = "sha256:0zhca08ij3rgrpcr3w385dfiwng129s44wsnmcxg7jhbqpyz2s5y";
  };
  gast_0_5 = self.callPackage ./common.nix {
    version = "0.5.2";
    sha256 = "sha256:05vysdd9hlivq91xyspsjj560xfsjcsjp8491cl0j4p5b1lsmzxa";
  };
  gast = gast_0_5;
}
