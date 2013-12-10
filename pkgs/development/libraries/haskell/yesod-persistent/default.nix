{ cabal, blazeBuilder, conduit, hspec, liftedBase, persistent
, persistentSqlite, persistentTemplate, poolConduit, resourcet
, text, transformers, waiTest, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "1.2.2";
  sha256 = "0pi7r6mf8ikd76cwdpjzb1lf73jc3f0ji3xximmg25q8lwcjygq5";
  buildDepends = [
    blazeBuilder conduit liftedBase persistent persistentTemplate
    poolConduit resourcet transformers yesodCore
  ];
  testDepends = [
    blazeBuilder conduit hspec persistent persistentSqlite text waiTest
    yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Some helpers for using Persistent from Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
