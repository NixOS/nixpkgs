{ cabal, active, colour, dataDefault, diagramsCore, monoidExtras
, newtype, NumInstances, semigroups, vectorSpace
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "0.6";
  sha256 = "05nfp5ggjk4fviwvwiblmzzw5dbzbi1w8dx5dimvah7wxb0km3lf";
  buildDepends = [
    active colour dataDefault diagramsCore monoidExtras newtype
    NumInstances semigroups vectorSpace
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
