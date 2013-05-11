{ cabal, accelerate, bmp, repa, vector }:

cabal.mkDerivation (self: {
  pname = "accelerate-io";
  version = "0.13.0.0";
  sha256 = "08mlmb7ipdyh4nzv6dsfszack5glm0ihr34capa0ilq4c7cvwlv5";
  buildDepends = [ accelerate bmp repa vector ];
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate-io";
    description = "Read and write Accelerate arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
