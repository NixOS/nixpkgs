{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml
, blazeMarkup, conduit, hspec, liftedBase, monadControl
, monadLogger, pathPieces, poolConduit, resourcet, scientific
, silently, sqlite, text, time, transformers, transformersBase
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "1.3.0.2";
  sha256 = "16bq0l6nqjpzlbzm47ip2m8b5yhwhf28fpv3hxy7qsnzmy7siv6y";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeHtml blazeMarkup conduit
    liftedBase monadControl monadLogger pathPieces poolConduit
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
