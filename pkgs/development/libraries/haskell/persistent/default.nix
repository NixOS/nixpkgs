{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml, conduit
, liftedBase, monadControl, mtl, pathPieces, poolConduit, resourcet
, sqlite, text, time, transformers, transformersBase
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.9.0";
  sha256 = "00nd76is0yijzh52a5dgv00v30mcign9j86lmmfbpxpaa460g3hn";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeHtml conduit liftedBase
    monadControl mtl pathPieces poolConduit resourcet text time
    transformers transformersBase unorderedContainers vector
  ];
  extraLibraries = [ sqlite ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, multi-backend data serialization";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
