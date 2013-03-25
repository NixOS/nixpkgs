{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "blaze-builder";
  version = "0.3.1.1";
  sha256 = "1pnw5kjpyxf3mh72cb9a0f1qwpq3a2bkgqp1j3ny8l6nmzw0c9d1";
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
