{cabal, blazeBuilder, languageJavascript, text} :

cabal.mkDerivation (self : {
  pname = "hjsmin";
  version = "0.0.14";
  sha256 = "16053hnxnr9vsqvasbibjwjdg0jpsl5fwzgy54ac1xkh4rhp3a5i";
  propagatedBuildInputs = [ blazeBuilder languageJavascript text ];
  meta = {
    homepage = "http://github.com/alanz/hjsmin";
    description = "Haskell implementation of a javascript minifier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
