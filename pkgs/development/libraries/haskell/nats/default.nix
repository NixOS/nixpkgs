{ cabal }:

cabal.mkDerivation (self: {
  pname = "nats";
  version = "0.1.2";
  sha256 = "1r4083p8sbnqs74l8faqfs1i97k8bql762l55pbmapy0p1xrkzka";
  meta = {
    homepage = "http://github.com/ekmett/nats/";
    description = "Haskell 98 natural numbers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
