{ cabal, attoparsec, cssText, hspec, HUnit, network, tagsoup, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "xss-sanitize";
  version = "0.3.4.1";
  sha256 = "11s7vkp8c7gdfv9vaq81p954jsc319xrfi9vv6wgfb3pqjf800mh";
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
