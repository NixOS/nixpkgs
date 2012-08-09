{ cabal, persistent, persistentTemplate, transformers, yesodCore }:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "1.1.0";
  sha256 = "0c8cvc2gy9ixa0h79ycnyi86indny2i86g5xcg30a2rvc4mjbaaj";
  buildDepends = [
    persistent persistentTemplate transformers yesodCore
  ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Some helpers for using Persistent from Yesod";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
