{ cabal, extensibleExceptions, transformers }:

cabal.mkDerivation (self: {
  pname = "MonadCatchIO-transformers";
  version = "0.2.2.3";
  sha256 = "1qwy9rrmf3kl7rb7v46n81xmrwy4xl63lfnlsiz1qc0hybjkl7m6";
  buildDepends = [ extensibleExceptions transformers ];
  meta = {
    description = "Monad-transformer compatible version of the Control.Exception module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
