{ cabal, stm, transformers }:

cabal.mkDerivation (self: {
  pname = "exception-transformers";
  version = "0.3.0.2";
  sha256 = "1ah3dimnc980vkr2lycpl4nsb615gxqws6mv9j90mz6g165h9khf";
  buildDepends = [ stm transformers ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Type classes and monads for unchecked extensible exceptions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
