{ cabal, exceptions, hspec, liftedBase, mmorph, monadControl, mtl
, QuickCheck, resourcet, text, textStreamDecode, transformers
, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.1.0";
  sha256 = "17y8fnvl9s3676sslhc04abs4zqh90l2rdcazxglv0sfrfsdgwnq";
  buildDepends = [
    exceptions liftedBase mmorph monadControl mtl resourcet text
    textStreamDecode transformers transformersBase void
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
