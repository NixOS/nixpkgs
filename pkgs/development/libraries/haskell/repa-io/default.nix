{ cabal, binary, bmp, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-io";
  version = "3.2.3.1";
  sha256 = "19dnz8xa18yydprnwzgdcbrndi6akwc53rs1104z0awffh83iynm";
  buildDepends = [ binary bmp repa vector ];
  jailbreak = true;
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Read and write Repa arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
