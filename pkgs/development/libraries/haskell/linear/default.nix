{ cabal, binary, distributive, doctest, filepath, hashable, HUnit
, lens, reflection, semigroupoids, semigroups, simpleReflect
, tagged, testFramework, testFrameworkHunit, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "linear";
  version = "1.3.1.1";
  sha256 = "174pqqc2gx8aigm51hfg7di35qbx65sgcqv6y1p25c2853g9h97y";
  buildDepends = [
    binary distributive hashable reflection semigroupoids semigroups
    tagged transformers unorderedContainers vector
  ];
  testDepends = [
    binary doctest filepath HUnit lens simpleReflect testFramework
    testFrameworkHunit
  ];
  meta = {
    homepage = "http://github.com/ekmett/linear/";
    description = "Linear Algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
