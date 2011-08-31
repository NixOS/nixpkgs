{ cabal }:

cabal.mkDerivation (self: {
  pname = "xhtml";
  version = "3000.2.0.2";
  sha256 = "14xfx4kmcl6xjn7lnpjd975wh8xakfpd8clcm5bw5n3g0b7agfli";
  meta = {
    description = "An XHTML combinator library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
