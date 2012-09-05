{ cabal, diagramsCairo, diagramsCore, diagramsLib }:

cabal.mkDerivation (self: {
  pname = "diagrams";
  version = "0.5";
  sha256 = "163h2fg3gpmsfm57gjyja2rxh9pl6s3xnzlidfdy201zbk1mzdg5";
  buildDepends = [ diagramsCairo diagramsCore diagramsLib ];
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative vector graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
