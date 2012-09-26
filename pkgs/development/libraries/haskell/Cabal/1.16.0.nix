{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "Cabal";
  version = "1.16.0";
  sha256 = "0ia2ysqbnnbfv75l8617bys5iaq8aygcbd1ijqcbzd3asf8flyms";
  buildDepends = [ filepath ];
  meta = {
    homepage = "http://www.haskell.org/cabal/";
    description = "A framework for packaging Haskell software";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
