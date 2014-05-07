{ cabal, exceptions, hspec, liftedBase, mmorph, monadControl, mtl
, QuickCheck, resourcet, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.1.2.1";
  sha256 = "1jzc3vnc0dr4nm79yx2kk5rsm06jfbf3h89y28bgv05r1pw6r7ai";
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
