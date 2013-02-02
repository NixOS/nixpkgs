{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "ghc-heap-view";
  version = "0.4.1.0";
  sha256 = "1icq5620j37n85d08yfpln75f9944flbqyqhjqsf0qr72zsm3w11";
  buildDepends = [ transformers ];
  meta = {
    description = "Extract the heap representation of Haskell values and thunks";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
