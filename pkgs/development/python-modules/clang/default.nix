self: rec {
  clang_11 = self.callPackage ./common.nix {
    version = "11.0";
    sha256 = "sha256:1igqqvnm3yrzy08fz9sszn1r9hr0jkhhms4pzcgckr8zbd3ycf7q";
  };
  clang = clang_11;
}
