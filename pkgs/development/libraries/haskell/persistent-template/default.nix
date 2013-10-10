{ cabal, aeson, hspec, monadControl, monadLogger, persistent
, QuickCheck, text, thOrphans, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.2.0.3";
  sha256 = "10scyrfa8g79v8ra79bp0bg7q6iwqjw6jpm06g11pngv4x9zx880";
  buildDepends = [
    aeson monadControl monadLogger persistent text thOrphans
    transformers
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
