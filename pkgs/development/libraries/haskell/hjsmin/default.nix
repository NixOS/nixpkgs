{ cabal, blazeBuilder, languageJavascript, text }:

cabal.mkDerivation (self: {
  pname = "hjsmin";
  version = "0.1.2";
  sha256 = "04yk383504blg8x10x5j1fd5mzyybqkhz7jfsyimvz2wz2v86qsb";
  buildDepends = [ blazeBuilder languageJavascript text ];
  meta = {
    homepage = "http://github.com/alanz/hjsmin";
    description = "Haskell implementation of a javascript minifier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
