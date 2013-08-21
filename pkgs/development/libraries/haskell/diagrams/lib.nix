{ cabal, active, colour, dataDefaultClass, diagramsCore, fingertree
, intervals, monoidExtras, newtype, NumInstances, semigroups
, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "0.7";
  sha256 = "02zb9j2qb5f26azscv1m4iivp1ixdhx6rcjns5smka1hdgyzld1j";
  buildDepends = [
    active colour dataDefaultClass diagramsCore fingertree intervals
    monoidExtras newtype NumInstances semigroups vectorSpace
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
