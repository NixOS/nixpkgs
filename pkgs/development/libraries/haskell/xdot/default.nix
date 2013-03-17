{ cabal, cairo, graphviz, gtk, mtl, polyparse, text }:

cabal.mkDerivation (self: {
  pname = "xdot";
  version = "0.2.3";
  sha256 = "0xb8igsqydiw1w00frn4mxkflhxkayif2vivxmq5fk53am2f43wy";
  buildDepends = [ cairo graphviz gtk mtl polyparse text ];
  meta = {
    description = "Parse Graphviz xdot files and interactively view them using GTK and Cairo";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
