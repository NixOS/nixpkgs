{ cabal, aeson, hspec, monadControl, monadLogger, persistent
, QuickCheck, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.3.1.1";
  sha256 = "13rbsxfrync5vmg5f1h5z5lc2b1vvh7nzbap4s5g5df3nvzfmmqx";
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
