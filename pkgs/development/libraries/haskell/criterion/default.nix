{cabal, deepseq, mtl, mwcRandom, parsec, statistics, vector,
 vectorAlgorithms} :

cabal.mkDerivation (self : {
  pname = "criterion";
  version = "0.5.0.10";
  sha256 = "0sd289s7wnyg0p37j327hv55aw4a18bdv56z26v4qi3j8p2fbpbj";
  propagatedBuildInputs = [
    deepseq mtl mwcRandom parsec statistics vector vectorAlgorithms
  ];
  meta = {
    homepage = "http://bitbucket.org/bos/criterion";
    description = "Robust, reliable performance measurement and analysis";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
