{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml, conduit
, liftedBase, monadControl, mtl, pathPieces, poolConduit, sqlite
, text, time, transformers, transformersBase, unorderedContainers
, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.8.0.2";
  sha256 = "10v11fnx7dhj2gg09k3ji054iywbpazs789vhfxn56wfg6rz59wb";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeHtml conduit liftedBase
    monadControl mtl pathPieces poolConduit text time transformers
    transformersBase unorderedContainers vector
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
