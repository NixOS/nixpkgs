{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml
, blazeMarkup, conduit, hspec, liftedBase, monadControl
, monadLogger, pathPieces, poolConduit, resourcet, scientific
, silently, sqlite, text, time, transformers, transformersBase
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "1.3.0.3";
  sha256 = "0p9h43wvm1l9va6s6p71y6r5ifgvbqz8ypc86pmzbphq6712jnsl";
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
