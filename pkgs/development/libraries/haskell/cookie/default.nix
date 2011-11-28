{ cabal, blazeBuilder, text, time }:

cabal.mkDerivation (self: {
  pname = "cookie";
  version = "0.3.0.2";
  sha256 = "123ylraxcavj82qcvrbfpb172k8zl5qgzh2byv84did1f1dz0ris";
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
