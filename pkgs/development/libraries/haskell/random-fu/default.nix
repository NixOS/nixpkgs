{cabal, erf, gamma, monadLoops, mtl, randomShuffle, randomSource,
 rvar, syb, transformers, vector} :

cabal.mkDerivation (self : {
  pname = "random-fu";
  version = "0.2";
  sha256 = "1w5bqhhh07xr377whgfbzn57p77j8ng5nmy2rx8qnqyw8smlkxzm";
  propagatedBuildInputs = [
    erf gamma monadLoops mtl randomShuffle randomSource rvar syb
    transformers vector
  ];
  meta = {
    homepage = "https://github.com/mokus0/random-fu";
    description = "Random number generation";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
