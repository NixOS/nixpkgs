{ cabal, Cabal, deepseq, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "dlist";
  version = "0.7.0.1";
  sha256 = "197k608ja69xc531r7h3gmy1mf6dsk27b3mkpgp4zdw46z6lcb5l";
  buildDepends = [ deepseq ];
  testDepends = [ Cabal QuickCheck ];
  meta = {
    homepage = "https://github.com/spl/dlist";
    description = "Difference lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
