{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml
, blazeMarkup, conduit, hspec, liftedBase, monadControl
, monadLogger, pathPieces, resourcePool, resourcet, scientific
, silently, sqlite, text, time, transformers, transformersBase
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "1.3.0.6";
  sha256 = "0rj5yi8nziym9cb9c9vw6vdjflf2yfz02i39p6dsdy084f1ivpk8";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeHtml blazeMarkup conduit
    liftedBase monadControl monadLogger pathPieces resourcePool
    resourcet scientific silently text time transformers
    transformersBase unorderedContainers vector
  ];
  testDepends = [
    aeson attoparsec base64Bytestring blazeHtml conduit hspec
    monadControl monadLogger pathPieces resourcet scientific text time
    transformers unorderedContainers vector
  ];
  extraLibraries = [ sqlite ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, multi-backend data serialization";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
