{ cabal, adjunctions, binary, distributive, doctest, filepath
, hashable, HUnit, lens, reflection, semigroupoids, semigroups
, simpleReflect, tagged, testFramework, testFrameworkHunit
, transformers, unorderedContainers, vector, void
}:

cabal.mkDerivation (self: {
  pname = "linear";
  version = "1.10";
  sha256 = "1wl0hb58znc3n5f5jv0wm6g21p080zldlq954n0lm8sjwmv39cdx";
  buildDepends = [
    adjunctions binary distributive hashable lens reflection
    semigroupoids semigroups tagged transformers unorderedContainers
    vector void
  ];
  testDepends = [
    binary doctest filepath HUnit lens simpleReflect testFramework
    testFrameworkHunit
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/ekmett/linear/";
    description = "Linear Algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
