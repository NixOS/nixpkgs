{ cabal, aeson, hspec, monadControl, monadLogger, persistent
, QuickCheck, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.2.0.2";
  sha256 = "0zj35mg7fzyk4b98s3s8m5i064s0wznz9aixgxa4kzm4xps7hj4z";
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
