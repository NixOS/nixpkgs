{cabal, QuickCheck} :

cabal.mkDerivation (self : {
  pname = "Vec";
  version = "0.9.8";
  sha256 = "0yaqy0p2jh2ajf8897vsxl5w6bmavixn6n5cc7w8kdnybpbdms6v";
  propagatedBuildInputs = [ QuickCheck ];
  meta = {
    homepage = "http://graphics.cs.ucdavis.edu/~sdillard/Vec";
    description = "Fixed-length lists and low-dimensional linear algebra.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
