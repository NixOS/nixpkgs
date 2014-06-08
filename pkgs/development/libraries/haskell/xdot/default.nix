{ cabal, cairo, graphviz, gtk, mtl, polyparse, text }:

cabal.mkDerivation (self: {
  pname = "xdot";
  version = "0.2.4.3";
  sha256 = "0p6y3ng8nwi8sksy0881bs331asi73x816zd5v7qlg4v719s8jxg";
  buildDepends = [ cairo graphviz gtk mtl polyparse text ];
  jailbreak = true;
  meta = {
    description = "Parse Graphviz xdot files and interactively view them using GTK and Cairo";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
