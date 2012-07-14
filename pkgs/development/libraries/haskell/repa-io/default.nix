{ cabal, binary, bmp, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-io";
  version = "3.2.1.1";
  sha256 = "156amnlqsxhwalnc4nypcd66znv2f8c71d5xi8ja5g8d9f1yg02g";
  buildDepends = [ binary bmp repa vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Read and write Repa arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
