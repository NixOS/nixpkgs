{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "ghc-heap-view";
  version = "0.4.2.0";
  sha256 = "0c9yz47j0ddy0l04dabglc99hl7n9wwnz4xj9r8ljafag6l221gp";
  buildDepends = [ transformers ];
  meta = {
    description = "Extract the heap representation of Haskell values and thunks";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
