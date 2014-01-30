{ cabal, newtype, vectorSpace }:

cabal.mkDerivation (self: {
  pname = "vector-space-points";
  version = "0.1.3";
  sha256 = "0bk2zrccf5bxh14dzhhv89mr755j801ziqyxgv69ksdyxh8hx2qg";
  buildDepends = [ newtype vectorSpace ];
  meta = {
    description = "A type for points, as distinct from vectors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
