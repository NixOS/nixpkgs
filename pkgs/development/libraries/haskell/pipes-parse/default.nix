{ cabal, pipes, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-parse";
  version = "3.0.1";
  sha256 = "0f262p8mfcpvs3f3myy6bll9v61rfgrfdy2scdzf7vvx0h0lrpj7";
  buildDepends = [ pipes transformers ];
  meta = {
    description = "Parsing infrastructure for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
