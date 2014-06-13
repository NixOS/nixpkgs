{ cabal, extensibleExceptions, monadsTf, transformers }:

cabal.mkDerivation (self: {
  pname = "MonadCatchIO-transformers";
  version = "0.3.1.0";
  sha256 = "1r5syyalk8a81byhk39yp0j7vdrvlrpppbg52dql1fx6kfhysaxn";
  buildDepends = [ extensibleExceptions monadsTf transformers ];
  jailbreak = true;
  meta = {
    description = "Monad-transformer compatible version of the Control.Exception module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
