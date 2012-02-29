{ cabal, HUnit, mtl, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "testpack";
  version = "2.1.2";
  sha256 = "12dhl8svy0wmdwlvkp0p0j6wr6vgv4hrjcpdv48kc5rcwjvh8xif";
  buildDepends = [ HUnit mtl QuickCheck random ];
  meta = {
    homepage = "http://hackage.haskell.org/cgi-bin/hackage-scripts/package/testpack";
    description = "Test Utililty Pack for HUnit and QuickCheck";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
