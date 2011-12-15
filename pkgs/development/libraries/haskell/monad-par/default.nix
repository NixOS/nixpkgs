{ cabal, deepseq, HUnit }:

cabal.mkDerivation (self: {
  pname = "monad-par";
  version = "0.1.0.2";
  sha256 = "0ca5fbc92bmghg8pk40rwcf58jk3y7xcr0nwfhyhi67riqnwqrl8";
  buildDepends = [ deepseq HUnit ];
  meta = {
    homepage = "https://github.com/simonmar/monad-par";
    description = "A library for parallel programming based on a monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
