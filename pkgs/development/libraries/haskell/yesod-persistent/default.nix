{ cabal, persistent, persistentTemplate, transformers, yesodCore }:

cabal.mkDerivation (self: {
  pname = "yesod-persistent";
  version = "1.0.0";
  sha256 = "1dawhs9ab2z5njq9m37p9zrr5wdzrmw4i0ixb2j4rhff8z50hjaf";
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
