{cabal, deepseq, mtl, parallel, parsec, vector, vectorAlgorithms,
 mwcRandom, statistics, Chart, dataAccessor}:

cabal.mkDerivation (self : {
  pname = "criterion";
  version = "0.5.0.5";
  sha256 = "1b1g7a2ip07j0554cj4d0413859fbdkaxpcgq2znjz7wh8z5aabn";

  propagatedBuildInputs = [
    deepseq mtl parallel parsec vector vectorAlgorithms mwcRandom statistics
    Chart dataAccessor
  ];

  configureFlags = "-fchart";

  meta = {
    homepage = "http://bitbucket.org/bos/criterion";
    description = "Robust, reliable performance measurement and analysis";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
