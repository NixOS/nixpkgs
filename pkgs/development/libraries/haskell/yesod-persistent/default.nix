{ cabal, failure, persistent, persistentTemplate, transformers
, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "0.1.0";
  sha256 = "1h0kk3sx0c4c3pcg3s2c5kfy0kz7gci45h4gsgrkhkcgg0pg324c";
  buildDepends = [
    failure persistent persistentTemplate transformers yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Some helpers for using Persistent from Yesod.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
