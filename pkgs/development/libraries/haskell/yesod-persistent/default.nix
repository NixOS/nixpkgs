{ cabal, blazeBuilder, conduit, hspec, liftedBase, persistent
, persistentSqlite, persistentTemplate, poolConduit, resourcet
, text, transformers, waiTest, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "1.2.1";
  sha256 = "06kzxdbg3xw128zlacsf51qi7qnccw0gjnwscxshljgipiicfhfc";
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
