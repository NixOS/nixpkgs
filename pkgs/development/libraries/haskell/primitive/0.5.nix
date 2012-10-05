{ cabal }:

cabal.mkDerivation (self: {
  pname = "primitive";
  version = "0.5";
  sha256 = "0m2gv7lac7q24cy02bbc7hq41awjxzs8dcjc6j2nv8xiq14cp3mk";
  meta = {
    homepage = "http://code.haskell.org/primitive";
    description = "Primitive memory-related operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
