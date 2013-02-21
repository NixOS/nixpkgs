{ cabal }:

cabal.mkDerivation (self: {
  pname = "tagged";
  version = "0.4.4";
  sha256 = "0bc88q33pyz4sx429awhxmnjzvmsg7vwwsqi2w7yf8lrmz5ph08x";
  meta = {
    homepage = "http://github.com/ekmett/tagged";
    description = "Haskell 98 phantom types to avoid unsafely passing dummy arguments";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
