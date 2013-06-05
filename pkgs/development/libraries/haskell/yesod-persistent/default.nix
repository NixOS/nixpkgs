{ cabal, blazeBuilder, conduit, hspec, liftedBase, persistent
, persistentSqlite, persistentTemplate, poolConduit, resourcet
, text, transformers, waiTest, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "1.2.0";
  sha256 = "1gzzs62mnx2q15sm3hvlk18qjgk3bi828klgl2ckc0462f7z8d0k";
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
