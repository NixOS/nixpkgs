{ cabal, binary, bmp, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-io";
  version = "3.1.3.1";
  sha256 = "1ah5zqg3699p98820gs39xh1xipqdknlgkwxrdqsblnm33y1bqnb";
  buildDepends = [ binary bmp repa vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Read and write Repa arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
