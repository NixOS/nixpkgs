{ cabal, diagramsContrib, diagramsCore, diagramsLib, diagramsSvg }:

cabal.mkDerivation (self: {
  pname = "diagrams";
  version = "1.1";
  sha256 = "1fdacsa57w64hkcsrriwdgdxddd7gps97fyaz2rl8wfxcl96vclr";
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
