{ cabal, aeson, hspec, monadControl, monadLogger, persistent
, QuickCheck, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.3.1.2";
  sha256 = "1gdwwx55ihnqxgyw0wsx0pr4dcs2hdbp5xbnx6l1j03rn5x1sglq";
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
