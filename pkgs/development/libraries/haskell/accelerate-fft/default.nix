{ cabal, accelerate, accelerateCuda, cuda, cufft }:

cabal.mkDerivation (self: {
  pname = "accelerate-fft";
  version = "0.13.0.0";
  sha256 = "0gqdb7m0qf8wvccqnz9pafbvas3viwhr9i422cmfvjpxsmnzlcp7";
  buildDepends = [ accelerate accelerateCuda cuda cufft ];
  meta = {
    homepage = "https://github.com/AccelerateHS/accelerate-fft";
    description = "FFT using the Accelerate library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.none;
  };
})
