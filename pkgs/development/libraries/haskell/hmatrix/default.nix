{ cabal, binary, blas, deepseq, gsl, liblapack, random
, storableComplex, vector
}:

cabal.mkDerivation (self: {
  pname = "hmatrix";
  version = "0.15.0.1";
  sha256 = "0hm3jnh7lds74zyk2m8i3zcdmsv1jlvplrzlxxr68j1cqwfdxilg";
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
