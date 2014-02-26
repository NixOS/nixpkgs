{ cabal, hspec, liftedBase, mmorph, monadControl, mtl, QuickCheck
, resourcet, text, textStreamDecode, transformers, transformersBase
, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.15";
  sha256 = "1ciys2b7a6n5k0ld66wpjxnrs5ys5dvg9n5k8282bc5zsd54mb59";
  buildDepends = [
    liftedBase mmorph monadControl mtl resourcet text textStreamDecode
    transformers transformersBase void
  ];
  testDepends = [
    hspec mtl QuickCheck resourcet text transformers void
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming data processing library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
