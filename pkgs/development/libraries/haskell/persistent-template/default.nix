{ cabal, aeson, hspec, monadControl, monadLogger, persistent
, QuickCheck, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.2.0.4";
  sha256 = "0lhqv4mcai9r5mzj5h6fsd1hd8mv1458id0rb6q157192gywxhzf";
  buildDepends = [
    aeson monadControl monadLogger persistent text transformers
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
