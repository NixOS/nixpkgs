{ cabal, free, pipes, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-parse";
  version = "2.0.0";
  sha256 = "092y0a4lvll451gnbz6ddrqgh22bd69wi00c0zd8s0hmf2f53y0s";
  buildDepends = [ free pipes transformers ];
  meta = {
    description = "Parsing infrastructure for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
