{ cabal, blazeBuilder, languageJavascript, text }:

cabal.mkDerivation (self: {
  pname = "hjsmin";
  version = "0.1.0";
  sha256 = "071aa5xvg4arrmphrr6880kmgjifrglnhiabrc7iv0r5ycgav001";
  buildDepends = [ blazeBuilder languageJavascript text ];
  meta = {
    homepage = "http://github.com/alanz/hjsmin";
    description = "Haskell implementation of a javascript minifier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
