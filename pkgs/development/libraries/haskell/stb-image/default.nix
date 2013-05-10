{ cabal, bitmap }:

cabal.mkDerivation (self: {
  pname = "stb-image";
  version = "0.2.1";
  sha256 = "1mx6i5q56wy13fvpnypb2c6fk2z3i5xdfblkpazzc70p2dgxaf52";
  buildDepends = [ bitmap ];
  meta = {
    homepage = "http://code.haskell.org/~bkomuves/";
    description = "A wrapper around Sean Barrett's JPEG/PNG decoder";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
