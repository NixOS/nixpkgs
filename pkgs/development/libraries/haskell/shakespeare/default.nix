{ cabal, blazeBuilder, blazeHtml, failure, parsec, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "0.10.1";
  sha256 = "1ckzfxrs65n8cx0hm64c3jd4hbw48x1vi0cvnkz39k500jpq874f";
  buildDepends = [ blazeBuilder blazeHtml failure parsec text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
