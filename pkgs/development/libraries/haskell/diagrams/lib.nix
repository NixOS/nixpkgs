{ cabal, active, colour, dataDefault, diagramsCore, monoidExtras
, newtype, NumInstances, semigroups, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "0.6.0.3";
  sha256 = "0rc3m2v1bxlm5rz1pi1w4k37sbgmr9qv54rllsqan1kicafjaqw1";
  buildDepends = [
    active colour dataDefault diagramsCore monoidExtras newtype
    NumInstances semigroups vectorSpace
  ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
