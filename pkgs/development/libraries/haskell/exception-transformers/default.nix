{ cabal, HUnit, stm, transformers }:

cabal.mkDerivation (self: {
  pname = "exception-transformers";
  version = "0.3.0.3";
  sha256 = "0z3z5pppaqqbndd4fgv1czr8f9f4a8r86bwc3bcv88yf7y8cfbwz";
  buildDepends = [ stm transformers ];
  testDepends = [ HUnit transformers ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Type classes and monads for unchecked extensible exceptions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
