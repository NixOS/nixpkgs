{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "QuickCheck";
  version = "2.5.1.1";
  sha256 = "1ff2mhm27l8cc8nrsbw2z65dc9m7h879jykl5g7yqip5l88j0jcq";
  buildDepends = [ random ];
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
