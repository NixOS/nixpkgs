{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "mmorph";
  version = "1.0.0";
  sha256 = "10r8frcn6ar56n1vxy8rkys8j52f8xkqan8qxqanka1150k6khqk";
  buildDepends = [ transformers ];
  meta = {
    description = "Monad morphisms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
