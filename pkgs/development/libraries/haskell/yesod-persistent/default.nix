{ cabal, failure, persistent, persistentTemplate, transformers
, yesodCore
}:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "0.2.1";
  sha256 = "1ka8jsxr7i5rcjxnv82ykq34yqxqzxdvk4b3ck7pbvx2a4g7bxw9";
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
