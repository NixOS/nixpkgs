{ cabal }:

cabal.mkDerivation (self: {
  pname = "binary";
  version = "0.6.0.0";
  sha256 = "0p72w7f9nn19g2wggsh8x4z7y9s174f3drz9a5ln4x7h554swcxv";
  meta = {
    homepage = "https://github.com/kolmodin/binary";
    description = "Binary serialisation for Haskell values using lazy ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
