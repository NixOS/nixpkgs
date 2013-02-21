{ cabal, blazeBuilder, languageJavascript, text }:

cabal.mkDerivation (self: {
  pname = "hjsmin";
  version = "0.1.4.1";
  sha256 = "0r73hd6kn37mdbm2i3g6v3qqm696kyflqs6ajq68qr5sr62sjb1a";
  buildDepends = [ blazeBuilder languageJavascript text ];
  meta = {
    homepage = "http://github.com/alanz/hjsmin";
    description = "Haskell implementation of a javascript minifier";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
