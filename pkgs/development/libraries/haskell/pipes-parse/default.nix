{ cabal, pipes, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-parse";
  version = "3.0.2";
  sha256 = "1d5lhh8knk0hmvd9wv2ihs5z9ybyvhd1n7qaazqkazqkyl14pd08";
  buildDepends = [ pipes transformers ];
  meta = {
    description = "Parsing infrastructure for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
