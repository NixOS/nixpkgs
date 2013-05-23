{ cabal, accelerate, bmp, repa, vector }:

cabal.mkDerivation (self: {
  pname = "accelerate-io";
  version = "0.13.0.1";
  sha256 = "0wjprbhcddnjqbhmpxiwq73hazdnhafhjj7mpvpxhs9pz1dbv89h";
  buildDepends = [ accelerate bmp repa vector ];
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate-io";
    description = "Read and write Accelerate arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
