{ cabal, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-text";
  version = "0.10.5";
  sha256 = "13nhasfbza73kv3iin16iidwyz71b8d75vq0ym37zygpxb5izkvw";
  buildDepends = [ shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/templates";
    description = "Interpolation with quasi-quotation: put variables strings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
