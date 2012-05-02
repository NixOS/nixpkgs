{ cabal, blazeBuilder, languageJavascript, text }:

cabal.mkDerivation (self: {
  pname = "hjsmin";
  version = "0.1.1";
  sha256 = "0v28z5l5fraf09b65j0fm75b702xp1s4ar8p5g9kigfn1wh8b62k";
  buildDepends = [ blazeBuilder languageJavascript text ];
  meta = {
    homepage = "http://github.com/alanz/hjsmin";
    description = "Haskell implementation of a javascript minifier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
