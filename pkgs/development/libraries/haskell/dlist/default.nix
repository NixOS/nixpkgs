{ cabal, Cabal, deepseq, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "dlist";
  version = "0.7";
  sha256 = "1abbym3afm77xkgcrv3d9nl4wn69m7m3gxahdcvkg1ir1sm2pkyi";
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
