{ cabal, distributive, doctest, filepath, hashable, HUnit, lens
, reflection, semigroupoids, semigroups, simpleReflect, tagged
, testFramework, testFrameworkHunit, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "linear";
  version = "1.3";
  sha256 = "0b5qjsbdkqv0h1236lv2nisjh9yz7gc5bd6xv6i8q5jryzs43pi9";
  buildDepends = [
    distributive hashable reflection semigroupoids semigroups tagged
    transformers unorderedContainers vector
  ];
  testDepends = [
    doctest filepath HUnit lens simpleReflect testFramework
    testFrameworkHunit
  ];
  meta = {
    homepage = "http://github.com/ekmett/linear/";
    description = "Linear Algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
