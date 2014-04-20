{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "lens-family-core";
  version = "1.0.0";
  sha256 = "149wfxddw58h5q42r3nknmac8wsc9c8xzsw6vrlfb4yasg7bhw53";
  buildDepends = [ transformers ];
  meta = {
    description = "Haskell 98 Lens Families";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
