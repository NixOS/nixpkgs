{ cabal, blazeBuilder, blazeHtml, failure, parsec, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "0.10.0";
  sha256 = "14q0z2q7c27pp6hnwzn50zjb4rzhy7znmahnzn8b59274jkbbzjs";
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
