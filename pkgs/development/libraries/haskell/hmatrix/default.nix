{ cabal, binary, blas, deepseq, gsl, liblapack, random
, storableComplex, vector
}:

cabal.mkDerivation (self: {
  pname = "hmatrix";
  version = "0.15.0.0";
  sha256 = "1n3m36kkgxhhmm7cmz4is9q558dw3l5h1laxnxwhs3cfdzfclyfs";
  buildDepends = [ binary deepseq random storableComplex vector ];
  extraLibraries = [ blas gsl liblapack ];
  meta = {
    homepage = "https://github.com/albertoruiz/hmatrix";
    description = "Linear algebra and numerical computation";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.guibert
    ];
  };
})
