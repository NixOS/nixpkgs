{ cabal, exceptions, hspec, liftedBase, mmorph, monadControl, mtl
, QuickCheck, resourcet, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.1.0.2";
  sha256 = "16pcdwgh9g7p7ali3sp0zpx1cwdgvyfwhgwcinnmaixxr6fsqqay";
  buildDepends = [
    exceptions liftedBase mmorph monadControl mtl resourcet
    transformers transformersBase void
  ];
  testDepends = [ hspec mtl QuickCheck resourcet transformers void ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming data processing library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
