{ cabal }:

cabal.mkDerivation (self: {
  pname = "file-embed";
  version = "0.0.4.3";
  sha256 = "0iagibsab18czvam36si88swzf5sijm4phwy4za6gnn4z71nb9s6";
  meta = {
    homepage = "https://github.com/snoyberg/file-embed";
    description = "Use Template Haskell to embed file contents directly";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
