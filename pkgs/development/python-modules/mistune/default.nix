self: rec {
  mistune_0_8 = self.callPackage ./common.nix {
    version = "0.8.4";
    sha256 = "59a3429db53c50b5c6bcc8a07f8848cb00d7dc8bdb431a4ab41920d201d4756e";
  };
  mistune_2_0 = self.callPackage ./common.nix {
    version = "2.0.4";
    sha256 = "sha256-nuCmYFPiJnq6dyxx4GiR+o8a9tSwHV6E4me0Vw1NmAg=";
    format = "pyproject";
  };
  mistune = mistune_0_8;
}
