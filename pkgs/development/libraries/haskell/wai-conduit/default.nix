{ cabal, blazeBuilder, conduit, httpTypes, transformers, wai }:

cabal.mkDerivation (self: {
  pname = "wai-conduit";
  version = "3.0.0";
  sha256 = "0v92jyxkigq7yj3hzy7kg360036nav986ny7b558l6j7zc90jsdg";
  buildDepends = [ blazeBuilder conduit httpTypes transformers wai ];
  meta = {
    homepage = "https://github.com/yesodweb/wai";
    description = "conduit wrappers for WAI";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
