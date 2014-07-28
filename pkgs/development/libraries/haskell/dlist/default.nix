{ cabal, Cabal, deepseq, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "dlist";
  version = "0.7.1";
  sha256 = "13ka30bn742ldacfgj2lhxvhwf769d0ziy2358vmd5xaq6fn1xfr";
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
