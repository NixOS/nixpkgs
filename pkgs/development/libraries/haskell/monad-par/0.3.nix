{ cabal, abstractDeque, abstractPar, deepseq, monadParExtras, mtl
, mwcRandom, parallel
}:

cabal.mkDerivation (self: {
  pname = "monad-par";
  version = "0.3";
  sha256 = "19vzz8qhv8z84grcb4myivmmaj0sn7rm956nqxv5dh2l8c279zsd";
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
