{ cabal, binary, bmp, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-io";
  version = "3.2.5.1";
  sha256 = "0aizsr6r1ybydpwqiamcdr4jhvqh0fiq9gbd7n17lrmnagyla5n8";
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
