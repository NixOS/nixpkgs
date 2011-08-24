{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "blaze-builder";
  version = "0.3.0.1";
  sha256 = "1p3xlifcr7v987zx8l2sppn9yydph332mn1xxk0yfi78a6386nfb";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/meiersi/blaze-builder";
    description = "Efficient buffered output";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
