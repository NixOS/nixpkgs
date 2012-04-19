{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml, conduit
, liftedBase, monadControl, pathPieces, poolConduit, resourcet
, sqlite, text, time, transformers, transformersBase
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.9.0.2";
  sha256 = "0m9m13gyjmzk33da2jd0b4l061n0gg6xj6rrnrnli2n8f70ywlnv";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeHtml conduit liftedBase
    monadControl pathPieces poolConduit resourcet text time
    transformers transformersBase unorderedContainers vector
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
