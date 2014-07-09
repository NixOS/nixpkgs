{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "lens-family-core";
  version = "1.1.0";
  sha256 = "0pvc7iv7y5s3496w7ic9qzdw3l76ldnrg0my0jxi1dyn0vm9xwm3";
  buildDepends = [ transformers ];
  meta = {
    description = "Haskell 98 Lens Families";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
