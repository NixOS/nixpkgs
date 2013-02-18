{ cabal, abstractDeque, abstractPar, deepseq, monadParExtras, mtl
, mwcRandom, parallel
}:

cabal.mkDerivation (self: {
  pname = "monad-par";
  version = "0.3.4";
  sha256 = "1j1xskd8smpfi2dpiwnpwakw0hs0i2yn1lrs9l06wz4b148hwc4k";
  buildDepends = [
    abstractDeque abstractPar deepseq monadParExtras mtl mwcRandom
    parallel
  ];
  meta = {
    homepage = "https://github.com/simonmar/monad-par";
    description = "A library for parallel programming based on a monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
