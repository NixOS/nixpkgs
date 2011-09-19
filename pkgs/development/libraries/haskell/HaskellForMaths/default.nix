{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "HaskellForMaths";
  version = "0.4.0";
  sha256 = "1x6kac1im07cpb1014ci8v222q66w2g3gr1wdcv2yvdi5g24ymbp";
  buildDepends = [ random ];
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
