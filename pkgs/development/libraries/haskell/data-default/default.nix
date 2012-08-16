{ cabal, dlist }:

cabal.mkDerivation (self: {
  pname = "data-default";
  version = "0.5.0";
  sha256 = "1wv8wjd9j40s7h19aph5pqph7rby5ma1nlagqywn9q0634iq9n2a";
  buildDepends = [ dlist ];
  meta = {
    description = "A class for types with a default value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
