{ cabal, parsec, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "0.10.2";
  sha256 = "173pcdm69w1xg3vm31xh6hs9w1552cmb1pz99ri09h1ajdhf2qwc";
  buildDepends = [ parsec text ];
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
