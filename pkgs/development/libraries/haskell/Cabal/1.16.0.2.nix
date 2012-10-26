{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "Cabal";
  version = "1.16.0.2";
  sha256 = "1yqzcml460ya98b0ylik1591zwinr8pa3q3wgw894x7m55g321db";
  buildDepends = [ filepath ];
  meta = {
    homepage = "http://www.haskell.org/cabal/";
    description = "A framework for packaging Haskell software";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
