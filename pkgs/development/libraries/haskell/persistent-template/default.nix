{ cabal, aeson, hspec, monadControl, monadLogger, persistent
, QuickCheck, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.2.0.5";
  sha256 = "1i1rfs1x9dfm89zib1wy0wsksk3cfwkz84b492v6751v8ysdfsjh";
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
