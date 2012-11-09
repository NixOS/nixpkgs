{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "Cabal";
  version = "1.16.0.3";
  sha256 = "11lzqgdjaix8n7nabmafl3jf9gisb04c025cmdycfihfajfn49zg";
  buildDepends = [ filepath ];
  meta = {
    homepage = "http://www.haskell.org/cabal/";
    description = "A framework for packaging Haskell software";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
