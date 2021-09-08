self: rec {
  # Used by tensorflow 2.6.0
  clang_5 = self.callPackage ./common.nix {
    version = "5.0";
    sha256 = "sha256:0fiklmj68x078hzaap46q8jq691f21hzsbyl8idml8m0xnbsxk6f";
  };
  clang_11 = self.callPackage ./common.nix {
    version = "11.0";
    sha256 = "sha256:1igqqvnm3yrzy08fz9sszn1r9hr0jkhhms4pzcgckr8zbd3ycf7q";
  };
  clang = clang_11;
}
