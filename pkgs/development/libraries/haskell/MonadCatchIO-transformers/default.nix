{ cabal, extensibleExceptions, monadsTf, transformers }:

cabal.mkDerivation (self: {
  pname = "MonadCatchIO-transformers";
  version = "0.3.1.1";
  sha256 = "1kfq9py053zic69f25gcsm802dhk7y5k01ipsf2jvl8d4r5iw5kk";
  buildDepends = [ extensibleExceptions monadsTf transformers ];
  jailbreak = true;
  meta = {
    description = "Monad-transformer compatible version of the Control.Exception module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
