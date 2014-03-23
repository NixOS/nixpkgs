{ cabal, hspec, liftedBase, mmorph, monadControl, mtl, QuickCheck
, resourcet, text, textStreamDecode, transformers, transformersBase
, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.17";
  sha256 = "0skshic2glx0sfy75skj8b4iip62zha51pgnnx5hsswhx8j2whcw";
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
