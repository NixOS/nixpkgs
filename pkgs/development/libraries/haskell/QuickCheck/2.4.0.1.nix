{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "QuickCheck";
  version = "2.4.0.1"; # Haskell Platform 2011.2.0.0
  sha256 = "1x7jc2svpxbll8qkrbswh5q59sqcjf2v5a6jnqslf5gwr5qpq18r";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Automatic testing of Haskell programs";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

