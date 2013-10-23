{ cabal, binary, distributive, doctest, filepath, hashable, HUnit
, lens, reflection, semigroupoids, semigroups, simpleReflect
, tagged, testFramework, testFrameworkHunit, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "linear";
  version = "1.3.1";
  sha256 = "1s07qbdi12rc4djk4s0ds5sh79qcqfmgrbwfj1ygskq3ra88qqsa";
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
