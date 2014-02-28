{ cabal, hspec, liftedBase, mmorph, monadControl, mtl, QuickCheck
, resourcet, text, textStreamDecode, transformers, transformersBase
, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.15.1";
  sha256 = "0pbrsa00x8qr856532iinw9lyliwh7gwzyd1pshdmj3gkbqpf2bv";
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
