{ cabal, active, colour, dataDefault, diagramsCore, newtype
, NumInstances, semigroups, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "0.5.0.1";
  sha256 = "0spfsllr2z064cxkdqcij02f0ikxxmll2dqj7rfikp4738wj21dy";
  buildDepends = [
    active colour dataDefault diagramsCore newtype NumInstances
    semigroups vectorSpace
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
