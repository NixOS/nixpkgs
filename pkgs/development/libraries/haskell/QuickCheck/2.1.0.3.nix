{ cabal, extensibleExceptions, mtl }:

cabal.mkDerivation (self: {
  pname = "QuickCheck";
  version = "2.1.0.3";
  sha256 = "91a861233fe0a37a032d092dd5e8ec40c2c99fbbf0701081394eb244f23757b1";
  buildDepends = [ extensibleExceptions mtl ];
  meta = {
    homepage = "http://www.cs.chalmers.se/~koen";
    description = "Automatic testing of Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
