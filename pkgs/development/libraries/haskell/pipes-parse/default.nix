{ cabal, pipes, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-parse";
  version = "3.0.0";
  sha256 = "07ycdnx24qlysbf78sgfl2g8rfsrxnaiq1rimc4656in4cmcjn9g";
  buildDepends = [ pipes transformers ];
  meta = {
    description = "Parsing infrastructure for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
