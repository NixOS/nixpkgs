{ cabal, blazeBuilder, conduit, hspec, persistent, persistentSqlite
, persistentTemplate, resourcePool, resourcet, text, transformers
, waiTest, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "1.2.2.3";
  sha256 = "1699grrxb1qwfiivh9ihnczkcbwl4gcqdk7m02lc09r9gjr920p8";
  buildDepends = [
    blazeBuilder conduit persistent persistentTemplate resourcePool
    resourcet transformers yesodCore
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
