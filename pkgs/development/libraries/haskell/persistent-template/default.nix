{ cabal, aeson, hspec, monadControl, persistent, QuickCheck, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.1.3.1";
  sha256 = "0171x8mv3ff9ppllkp3mgpwa8p1zg3y6fykq70z9h0hx1ny0407p";
  buildDepends = [ aeson monadControl persistent text transformers ];
  testDepends = [ aeson hspec persistent QuickCheck text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
