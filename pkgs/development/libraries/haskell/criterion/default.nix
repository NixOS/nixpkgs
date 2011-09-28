{ cabal, aeson, deepseq, mtl, mwcRandom, parsec, statistics, time
, vector, vectorAlgorithms
}:

cabal.mkDerivation (self: {
  pname = "criterion";
  version = "0.5.1.0";
  sha256 = "0v43dm1d84zvn32q89dq0nh4dvqr4r6fjdzwcjac0mjics3iy29d";
  buildDepends = [
    aeson deepseq mtl mwcRandom parsec statistics time vector
    vectorAlgorithms
  ];
  meta = {
    homepage = "http://bitbucket.org/bos/criterion";
    description = "Robust, reliable performance measurement and analysis";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
