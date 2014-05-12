{ cabal, cairo, graphviz, gtk, mtl, polyparse, text }:

cabal.mkDerivation (self: {
  pname = "xdot";
  version = "0.2.4.2";
  sha256 = "0a5wmwcl3akw1n9xgdhvlrbvphvy9s528daax28137ixaphvrl0f";
  buildDepends = [ cairo graphviz gtk mtl polyparse text ];
  jailbreak = true;
  meta = {
    description = "Parse Graphviz xdot files and interactively view them using GTK and Cairo";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
