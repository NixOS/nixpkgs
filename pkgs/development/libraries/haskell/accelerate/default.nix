{ cabal }:

cabal.mkDerivation (self: {
  pname = "accelerate";
  version = "0.12.1.0";
  sha256 = "1zvrb36xvvzfdl0k7a25329mdplwa76k9wk0yf3za3j0kb20d4f4";
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate/";
    description = "An embedded language for accelerated array processing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
