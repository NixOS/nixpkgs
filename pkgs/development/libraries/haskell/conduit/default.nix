{ cabal, exceptions, hspec, liftedBase, mmorph, monadControl, mtl
, QuickCheck, resourcet, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.1.6";
  sha256 = "1nhjj5zz934fd6fdbmkl8xvnvlaprxccgpwxffmdgqwxhvxgprq3";
  buildDepends = [
    exceptions liftedBase mmorph monadControl mtl resourcet
    transformers transformersBase void
  ];
  testDepends = [
    exceptions hspec mtl QuickCheck resourcet transformers void
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
