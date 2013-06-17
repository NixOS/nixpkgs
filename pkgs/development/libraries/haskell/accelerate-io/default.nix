{ cabal, accelerate, bmp, repa, vector }:

cabal.mkDerivation (self: {
  pname = "accelerate-io";
  version = "0.13.0.2";
  sha256 = "0lm1kkjs5gbd70k554vi9977v4bxxcxaw39r9wmwxf8nx2qxvshh";
  buildDepends = [ accelerate bmp repa vector ];
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate-io";
    description = "Read and write Accelerate arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
