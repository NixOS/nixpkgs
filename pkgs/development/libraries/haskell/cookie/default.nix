{ cabal, blazeBuilder, text, time }:

cabal.mkDerivation (self: {
  pname = "cookie";
  version = "0.3.0.1";
  sha256 = "1gqz2q09fnbk8scd164mg02jsdh0sg5g06grr627qsjy583i2ad7";
  buildDepends = [ blazeBuilder text time ];
  meta = {
    homepage = "http://github.com/snoyberg/cookie";
    description = "HTTP cookie parsing and rendering";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
