{ cabal, attoparsec, cssText, hspec, HUnit, network, tagsoup, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "xss-sanitize";
  version = "0.3.4";
  sha256 = "0xal75mk90a2hj70ipgcj95n6yw8hiki1r1vzad918aq2ihjqa53";
  buildDepends = [
    attoparsec cssText network tagsoup text utf8String
  ];
  testDepends = [
    attoparsec cssText hspec HUnit network tagsoup text utf8String
  ];
  meta = {
    homepage = "http://github.com/yesodweb/haskell-xss-sanitize";
    description = "sanitize untrusted HTML to prevent XSS attacks";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
