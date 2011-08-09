{cabal, HUnit, QuickCheck} :

cabal.mkDerivation (self : {
  pname = "Crypto";
  version = "4.2.3";
  sha256 = "02wi8lyi27i8cdj8vclrl7vcng38srdzz9qpqwsc4y4lmvgg82br";
  propagatedBuildInputs = [ HUnit QuickCheck ];
  meta = {
    description = "Collects together existing Haskell cryptographic functions into a package";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
