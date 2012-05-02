{ cabal, deepseq }:

cabal.mkDerivation (self: {
  pname = "deepseq-th";
  version = "0.1.0.3";
  sha256 = "1xx88i55iskyxrpxbdg0srb64y5siqs1b8qj7bh3i1893qs9sha2";
  buildDepends = [ deepseq ];
  meta = {
    description = "Template Haskell based deriver for optimised NFData instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
