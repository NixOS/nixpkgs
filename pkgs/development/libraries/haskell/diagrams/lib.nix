{ cabal, active, colour, dataDefaultClass, diagramsCore, fingertree
, intervals, monoidExtras, newtype, NumInstances, semigroups
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "0.7.1.1";
  sha256 = "14d557y22dqyjr026vbawa2a2yjh7alh3rpavyidfdlrg48lqgrc";
  buildDepends = [
    active colour dataDefaultClass diagramsCore fingertree intervals
    monoidExtras newtype NumInstances semigroups vectorSpace
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
