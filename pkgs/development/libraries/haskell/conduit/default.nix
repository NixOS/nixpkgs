{ cabal, hspec, liftedBase, mmorph, monadControl, mtl, QuickCheck
, resourcet, text, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.9.2";
  sha256 = "1w00fjbq3fbzvf77yvm50vkif8hw6ay5s3i39csimhd4hfgv1ss8";
  buildDepends = [
    liftedBase mmorph monadControl mtl resourcet text transformers
    transformersBase void
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
