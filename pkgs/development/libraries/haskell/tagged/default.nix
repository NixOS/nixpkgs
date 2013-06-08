{ cabal }:

cabal.mkDerivation (self: {
  pname = "tagged";
  version = "0.6";
  sha256 = "0w2sx6lys074y5ck2ll53dmak39pfnckbh6llgmicrj4zhgcd8jm";
  meta = {
    homepage = "http://github.com/ekmett/tagged";
    description = "Haskell 98 phantom types to avoid unsafely passing dummy arguments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
