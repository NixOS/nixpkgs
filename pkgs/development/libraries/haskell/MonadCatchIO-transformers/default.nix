{cabal, transformers} :

cabal.mkDerivation (self : {
  pname = "MonadCatchIO-transformers";
  version = "0.2.2.2";
  sha256 = "083c0abwja447j0p8q0j15iv7bshchy83rfqw07b2hfy38467h9g";
  propagatedBuildInputs = [ transformers ];
  meta = {
    description = "Monad-transformer compatible version of the Control.Exception module";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
