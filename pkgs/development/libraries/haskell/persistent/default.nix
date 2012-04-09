{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml, conduit
, liftedBase, monadControl, pathPieces, poolConduit, resourcet
, sqlite, text, time, transformers, transformersBase
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.9.0.1";
  sha256 = "0qlvlv7rlxs4r5w5hr4vbj1bwjkn3nzpk2w8q52cnn2c37wz24h8";
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
