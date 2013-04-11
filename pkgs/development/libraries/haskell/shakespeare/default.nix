{ cabal, hspec, parsec, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "1.0.4";
  sha256 = "0aqcgfx3y9sbp7wvjmx6rxwi4r13qrfxs9a40gc00np03bpk1hxb";
  buildDepends = [ parsec text ];
  testDepends = [ hspec parsec text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
