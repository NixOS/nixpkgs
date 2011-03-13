{cabal, deepseq, mtl, parallel, parsec, vector, vectorAlgorithms,
 mwcRandom, statistics}:

cabal.mkDerivation (self : {
  pname = "criterion";
  version = "0.5.0.7";
  sha256 = "1f1vpc3cwvc6wjy7fras5kp1iap8abh6ap3w6pf75qpkbdrcd3dq";

  propagatedBuildInputs = [
    deepseq mtl parallel parsec vector vectorAlgorithms mwcRandom statistics
  ];

  meta = {
    homepage = "http://bitbucket.org/bos/criterion";
    description = "Robust, reliable performance measurement and analysis";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
