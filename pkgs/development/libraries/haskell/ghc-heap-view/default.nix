{ cabal, binary, transformers }:

cabal.mkDerivation (self: {
  pname = "ghc-heap-view";
  version = "0.5.0.1";
  sha256 = "1zqzv6r4nkzam51bb6pp2i1kkzhx5mnaqcn8wzr0hxbi5lc1088h";
  buildDepends = [ binary transformers ];
  meta = {
    description = "Extract the heap representation of Haskell values and thunks";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
