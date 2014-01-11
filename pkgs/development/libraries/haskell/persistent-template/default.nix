{ cabal, aeson, hspec, monadControl, monadLogger, persistent
, QuickCheck, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.3.1";
  sha256 = "148gznxqzd5743l0r3pc9g14gvanxpl6nfla2lhb2xsa162b2hjx";
  buildDepends = [
    aeson monadControl monadLogger persistent text transformers
    unorderedContainers
  ];
  testDepends = [
    aeson hspec persistent QuickCheck text transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
