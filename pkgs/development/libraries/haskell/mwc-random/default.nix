{ cabal, primitive, time, vector }:

cabal.mkDerivation (self: {
  pname = "mwc-random";
  version = "0.12.0.0";
  sha256 = "0c1gzf5nkcbfi2zlhh7ly8b4g2gcr0c1b76awk38g9as9qibgivr";
  buildDepends = [ primitive time vector ];
  meta = {
    homepage = "https://github.com/bos/mwc-random";
    description = "Fast, high quality pseudo random number generation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
