{ cabal, cairo, graphviz, gtk, mtl, polyparse, text }:

cabal.mkDerivation (self: {
  pname = "xdot";
  version = "0.2.3.1";
  sha256 = "1gricrnssxgzaq1z7nnyppmz284nix0m89477x22mal125pkcf7n";
  buildDepends = [ cairo graphviz gtk mtl polyparse text ];
  meta = {
    description = "Parse Graphviz xdot files and interactively view them using GTK and Cairo";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
