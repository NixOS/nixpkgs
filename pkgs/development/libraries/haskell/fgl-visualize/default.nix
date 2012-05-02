{ cabal, dotgen, fgl }:

cabal.mkDerivation (self: {
  pname = "fgl-visualize";
  version = "0.1";
  sha256 = "0ri6ywg7rj8qfyngjxvihw43s2h2l3w03fwq1ipn59cdcnah08bc";
  buildDepends = [ dotgen fgl ];
  meta = {
    description = "Convert FGL graphs to dot (graphviz) files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
