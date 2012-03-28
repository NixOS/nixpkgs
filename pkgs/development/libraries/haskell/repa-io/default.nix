{ cabal, binary, bmp, repa, repaBytestring, vector }:

cabal.mkDerivation (self: {
  pname = "repa-io";
  version = "2.2.0.1";
  sha256 = "1akp6xkfvbc7jmnzlrz4y5fncqrv9d06y981dndcv6lgxz4hv4j1";
  buildDepends = [ binary bmp repa repaBytestring vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Read and write Repa arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
