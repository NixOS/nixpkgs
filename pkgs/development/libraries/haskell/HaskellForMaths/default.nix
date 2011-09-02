{ cabal, QuickCheck, random }:

cabal.mkDerivation (self: {
  pname = "HaskellForMaths";
  version = "0.3.4";
  sha256 = "1cmhzcybv3kwvs058sjihdkqr72rygv2nmbcy8i485pk35yq31sm";
  buildDepends = [ QuickCheck random ];
  meta = {
    homepage = "http://haskellformaths.blogspot.com/";
    description = "Combinatorics, group theory, commutative algebra, non-commutative algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
