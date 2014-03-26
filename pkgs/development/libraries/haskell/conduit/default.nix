{ cabal, hspec, liftedBase, mmorph, monadControl, mtl, QuickCheck
, resourcet, text, textStreamDecode, transformers, transformersBase
, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.17.1";
  sha256 = "0s2cszwfmz7j249bdydh0d97r5br1p6nizw7ycbkxlmpcrmdvifk";
  buildDepends = [
    liftedBase mmorph monadControl mtl resourcet text textStreamDecode
    transformers transformersBase void
  ];
  testDepends = [
    hspec mtl QuickCheck resourcet text transformers void
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming data processing library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
