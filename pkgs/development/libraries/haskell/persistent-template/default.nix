{ cabal, aeson, hspec, monadControl, monadLogger, persistent
, QuickCheck, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.2.0.1";
  sha256 = "1l8ws4mijl0cwcl14ms8hibfgcn3y6b1679xc0cdyz1ifiymkdns";
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
