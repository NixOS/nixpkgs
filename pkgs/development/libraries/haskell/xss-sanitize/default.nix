{ cabal, attoparsec, cssText, hspec, HUnit, network, tagsoup, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "xss-sanitize";
  version = "0.3.3";
  sha256 = "0xnyp8nwglh4waawijk1q5z8higf8mggh6hp0pp6ys4bm7gsp74a";
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
