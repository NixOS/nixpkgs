{ cabal, Cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "Vec";
  version = "0.9.8";
  sha256 = "0yaqy0p2jh2ajf8897vsxl5w6bmavixn6n5cc7w8kdnybpbdms6v";
  buildDepends = [ Cabal QuickCheck ];
  meta = {
    homepage = "http://graphics.cs.ucdavis.edu/~sdillard/Vec";
    description = "Fixed-length lists and low-dimensional linear algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
