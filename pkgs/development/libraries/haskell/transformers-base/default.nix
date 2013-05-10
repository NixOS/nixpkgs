{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "transformers-base";
  version = "0.4.1";
  sha256 = "1d3w7k7smvdnnn4q6xpdhsj9zvj6372ihyhz4lrhdvgh72pfiaag";
  buildDepends = [ transformers ];
  meta = {
    homepage = "https://github.com/mvv/transformers-base";
    description = "Lift computations from the bottom of a transformer stack";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
