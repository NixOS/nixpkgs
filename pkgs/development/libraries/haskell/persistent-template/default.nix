{ cabal, aeson, hspec, monadControl, monadLogger, persistent
, QuickCheck, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.3.0";
  sha256 = "0amg5xncxgpc19yhj3gi7ldw126dy725pxj7kp43lbgggap0yfv9";
  buildDepends = [
    aeson monadControl monadLogger persistent text transformers
    unorderedContainers
  ];
  testDepends = [ aeson hspec persistent QuickCheck text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
