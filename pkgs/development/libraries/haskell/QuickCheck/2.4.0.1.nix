{ cabal, Cabal, extensibleExceptions, mtl, random }:

cabal.mkDerivation (self: {
  pname = "QuickCheck";
  version = "2.4.0.1";
  sha256 = "1x7jc2svpxbll8qkrbswh5q59sqcjf2v5a6jnqslf5gwr5qpq18r";
  buildDepends = [ Cabal extensibleExceptions mtl random ];
  meta = {
    homepage = "http://code.haskell.org/QuickCheck";
    description = "Automatic testing of Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
