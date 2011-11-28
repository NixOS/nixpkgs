{ cabal, failure, persistent, persistentTemplate, transformers
, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "0.2.2";
  sha256 = "0pgvckyn3l9ggw77hmdpxfx5iwdk36fcfx464rqfzdy28agax47c";
  buildDepends = [
    failure persistent persistentTemplate transformers yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Some helpers for using Persistent from Yesod";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
