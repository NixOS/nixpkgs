{ cabal, diagramsContrib, diagramsCore, diagramsLib, diagramsSvg }:

cabal.mkDerivation (self: {
  pname = "diagrams";
  version = "1.0";
  sha256 = "0l7d8l06g6nn6bkkwdn8ra9ir1dnqj6qsgdzd9jk78dqq5ihp7bg";
  buildDepends = [
    diagramsContrib diagramsCore diagramsLib diagramsSvg
  ];
  noHaddock = true;
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative vector graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
