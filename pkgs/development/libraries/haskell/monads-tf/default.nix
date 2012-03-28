{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "monads-tf";
  version = "0.1.0.0";
  sha256 = "1d38rddm9h8crs96zhzj87a3ygix0ipyxy0qcyas88k60fgavg5i";
  buildDepends = [ transformers ];
  meta = {
    description = "Monad classes, using type families";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
