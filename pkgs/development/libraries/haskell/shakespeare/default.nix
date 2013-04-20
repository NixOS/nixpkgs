{ cabal, fetchurl, hspec, parsec, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "1.0.4";
  sha256 = "0aqcgfx3y9sbp7wvjmx6rxwi4r13qrfxs9a40gc00np03bpk1hxb";
  buildDepends = [ parsec text ];
  testDepends = [ hspec parsec text ];
  patchFlags = "-p2";
  patches = [ (fetchurl { url = "https://github.com/yesodweb/shakespeare/pull/102.patch";
                          sha256 = "02fp87sw7k8zyn8kgmjg8974gi7pp5fyvb4f84i983qycmlmh8xq";
                        })
            ];
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
