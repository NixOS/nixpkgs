{ cabal, dlist }:

cabal.mkDerivation (self: {
  pname = "data-default";
  version = "0.3.0";
  sha256 = "0nbvknfa9kkc46fl1ffji0ghqb41wwsccmc55mya5zavfq9g05g9";
  buildDepends = [ dlist ];
  meta = {
    description = "A class for types with a default value";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
