{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "QuickCheck";
  version = "2.1.0.3"; # Haskell Platform 2010.1.0.0
  sha256 = "91a861233fe0a37a032d092dd5e8ec40c2c99fbbf0701081394eb244f23757b1";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Automatic testing of Haskell programs";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

