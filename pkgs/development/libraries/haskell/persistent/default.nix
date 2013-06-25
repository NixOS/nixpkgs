{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml
, blazeMarkup, conduit, hspec, liftedBase, monadControl
, monadLogger, pathPieces, poolConduit, resourcet, silently, sqlite
, text, time, transformers, transformersBase, unorderedContainers
, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "1.2.0.2";
  sha256 = "026zdfccy57dbsacg8227jzcdyq50nb1bkcr56ryxi91ymlyf50k";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeHtml blazeMarkup conduit
    liftedBase monadControl monadLogger pathPieces poolConduit
    resourcet silently text time transformers transformersBase
    unorderedContainers vector
  ];
  testDepends = [
    aeson attoparsec base64Bytestring blazeHtml conduit hspec
    monadControl monadLogger pathPieces resourcet text time
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
