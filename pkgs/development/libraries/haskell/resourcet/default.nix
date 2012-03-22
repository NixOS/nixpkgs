{ cabal, liftedBase, monadControl, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.3.0";
  sha256 = "1r7yyw8jzh1wxy03mv22hg1c9ff9s4iv86kfgnmva8nwmcgnv0a1";
  buildDepends = [
    liftedBase monadControl transformers transformersBase
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Deterministic allocation and freeing of scarce resources";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
