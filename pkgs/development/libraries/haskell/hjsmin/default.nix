{ cabal, blazeBuilder, languageJavascript, text }:

cabal.mkDerivation (self: {
  pname = "hjsmin";
  version = "0.0.16";
  sha256 = "0svpmhrzhra3yhc1bzwga9d13k4kd8vw6va1q9866pkw385j5jr4";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ blazeBuilder languageJavascript text ];
  meta = {
    homepage = "http://github.com/alanz/hjsmin";
    description = "Haskell implementation of a javascript minifier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
