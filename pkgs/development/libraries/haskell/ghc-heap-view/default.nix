{ cabal, binary, transformers }:

cabal.mkDerivation (self: {
  pname = "ghc-heap-view";
  version = "0.5";
  sha256 = "00sibiqq95xnjpf9gy0dajvpmmz3rxvi3lhm56vfds7ddnyxpv0c";
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
