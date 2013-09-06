{ cabal, diagramsContrib, diagramsCore, diagramsLib, diagramsSvg }:

cabal.mkDerivation (self: {
  pname = "diagrams";
  version = "0.7.1";
  sha256 = "0rdpp26zvimdhdw0jpw6w606jkzkqdx0pq4051fkyk2mldwk9ipj";
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
