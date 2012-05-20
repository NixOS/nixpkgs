{ cabal }:

cabal.mkDerivation (self: {
  pname = "accelerate";
  version = "0.12.0.0";
  sha256 = "1hb1zqsh8598brnjhdds8knp9dfsdlshrx5c7lj4pgl37gqyb5q5";
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate/";
    description = "An embedded language for accelerated array processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
