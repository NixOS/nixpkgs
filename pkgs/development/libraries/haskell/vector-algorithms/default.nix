{ cabal, primitive, vector }:

cabal.mkDerivation (self: {
  pname = "vector-algorithms";
  version = "0.5.3";
  sha256 = "14h2x3yrb4fji8bf84xbfp84pax6lzr8njc0c4061xpwcmair36j";
  buildDepends = [ primitive vector ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/";
    description = "Efficient algorithms for vector arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
