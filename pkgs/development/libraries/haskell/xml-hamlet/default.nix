{ cabal, hspec, HUnit, parsec, shakespeare, text, xmlConduit }:

cabal.mkDerivation (self: {
  pname = "xml-hamlet";
  version = "0.4.0.8";
  sha256 = "10hc4a6lqifiinm9rf1ziw35bjnjgkd5mhagg9anvz35hhr7bbrr";
  buildDepends = [ parsec shakespeare text xmlConduit ];
  testDepends = [ hspec HUnit parsec shakespeare text xmlConduit ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Hamlet-style quasiquoter for XML content";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
