{ cabal }:

cabal.mkDerivation (self: {
  pname = "primitive";
  version = "0.4.1";
  sha256 = "06999i59xhvjwfdbnr1n09zkvg7lnim64nqxqlvk0x6slkidb7f6";
  meta = {
    homepage = "http://code.haskell.org/primitive";
    description = "Wrappers for primitive operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
