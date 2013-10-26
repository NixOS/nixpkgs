{ cabal, cairo, graphviz, gtk, mtl, polyparse, text }:

cabal.mkDerivation (self: {
  pname = "xdot";
  version = "0.2.4";
  sha256 = "0723drp9zs3hrayld99j4fniyvm65fz19hkk4001vpvgjw27dfja";
  buildDepends = [ cairo graphviz gtk mtl polyparse text ];
  meta = {
    description = "Parse Graphviz xdot files and interactively view them using GTK and Cairo";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
