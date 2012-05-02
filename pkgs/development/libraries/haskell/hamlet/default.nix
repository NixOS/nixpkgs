{ cabal, blazeBuilder, blazeHtml, failure, parsec, shakespeare
, text
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "1.0.1.2";
  sha256 = "1lb1q2nkih7z63gh1rdwl4656ybmpdqic1d09q5jqgm6bjqrgw53";
  buildDepends = [
    blazeBuilder blazeHtml failure parsec shakespeare text
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Haml-like template files that are compile-time checked";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
