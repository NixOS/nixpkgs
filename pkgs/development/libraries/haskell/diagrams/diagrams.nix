{ cabal, diagramsContrib, diagramsCore, diagramsLib, diagramsSvg }:

cabal.mkDerivation (self: {
  pname = "diagrams";
  version = "0.7";
  sha256 = "08ibmxzykb9v8y7ars9jz2qyss8ln8i6j87sm31bq5g9kvpy287c";
  buildDepends = [
    diagramsContrib diagramsCore diagramsLib diagramsSvg
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative vector graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
