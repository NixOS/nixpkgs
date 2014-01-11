{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "mmorph";
  version = "1.0.1";
  sha256 = "15a4isvxb4my72hzndgfy66792r9fpkn9vnmr2fnv9d9vl058y14";
  buildDepends = [ transformers ];
  meta = {
    description = "Monad morphisms";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
