self: rec {
  mistune_0_8 = self.callPackage ./common.nix {
    version = "0.8.4";
    sha256 = "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e";
  };
  mistune_2_0 = self.callPackage ./common.nix {
    version = "2.0.0rc1";
    sha256 = "1nd7iav1ixh9hlj4hxn6lmpava88d86ys8rqm30wgvr7gjlxnas5";
  };
  mistune = mistune_0_8;
}
