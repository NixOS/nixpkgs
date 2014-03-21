{ cabal, adjunctions, binary, distributive, doctest, filepath
, hashable, HUnit, lens, reflection, semigroupoids, semigroups
, simpleReflect, tagged, testFramework, testFrameworkHunit
, transformers, unorderedContainers, vector, void
}:

cabal.mkDerivation (self: {
  pname = "linear";
  version = "1.9.1";
  sha256 = "17jvqy2nbcra36fzkwbjkfwg6mjw804zd1i50mhbqwg9j7z4s5sb";
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
