{cabal, fetchurl, syb, sourceFromHead}:

cabal.mkDerivation (self : {
  pname = "ghc-syb";
  version = "dev";
  name = self.fname;
  # REGION AUTO UPDATE:   { name="ghc_syb"; type = "git"; url = "git://github.com/nominolo/ghc-syb.git"; groups="haskell scien"; }
  src = sourceFromHead "ghc_syb-876b121e73f1b5ca4b17b0c6908b27ba7efb0374.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/ghc_syb-876b121e73f1b5ca4b17b0c6908b27ba7efb0374.tar.gz"; sha256 = "bb5071ee8a6a6cd99634e0f146c921592e8c77b13d511cde0c91fedc406a0a07"; });
  # END
  extraBuildInputs = [syb];
  meta = {
    description = "Source code suggestions";
  };
})
