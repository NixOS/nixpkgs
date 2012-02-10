{ cabal, persistent, persistentTemplate, transformers, yesodCore }:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "0.3.1";
  sha256 = "0pxzwqrq4wr9hdnppi5ri0iip2a8gg2y7lplmhn2791jc001ll7m";
  buildDepends = [
    persistent persistentTemplate transformers yesodCore
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
