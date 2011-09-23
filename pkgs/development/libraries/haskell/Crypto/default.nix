{ cabal, HUnit, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "Crypto";
  version = "4.2.4";
  sha256 = "05wafv8flrh1893rh208azzig5k5pa022s2fg3f8lrqb23c6v63p";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ HUnit QuickCheck random ];
  meta = {
    description = "Collects together existing Haskell cryptographic functions into a package";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
