{ cabal, attoparsec, cssText, hspec, HUnit, network, tagsoup, text
, utf8String
}:

cabal.mkDerivation (self: {
  pname = "xss-sanitize";
  version = "0.3.5";
  sha256 = "13iggcivpvzlzlx0n1pb6lyw55lc7d7hzihf1llphq6lmdy6l49s";
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
