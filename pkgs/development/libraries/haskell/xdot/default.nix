{ cabal, cairo, graphviz, gtk, mtl, polyparse, text }:

cabal.mkDerivation (self: {
  pname = "xdot";
  version = "0.2.4.1";
  sha256 = "1k1ci9lq8l9bx8ks7rdng9jjj6d7hcwgmfbz757al85m1q17xa64";
  buildDepends = [ cairo graphviz gtk mtl polyparse text ];
  meta = {
    description = "Parse Graphviz xdot files and interactively view them using GTK and Cairo";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
