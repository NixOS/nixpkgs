{ cabal, persistent, persistentTemplate, transformers, yesodCore }:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "1.0.0.1";
  sha256 = "1v4ip4g9x2a5byl0a9a1raad3aba7hs618vx7fnc5n2ajjji84mx";
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
