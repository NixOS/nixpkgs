{ cabal, newtype, vectorSpace }:

cabal.mkDerivation (self: {
  pname = "vector-space-points";
  version = "0.1.1.1";
  sha256 = "08lar9ydni87w79y86xk2blddsgx5n6gwz3262w8z32dgy9lrmwx";
  buildDepends = [ newtype vectorSpace ];
  meta = {
    description = "A type for points, as distinct from vectors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
