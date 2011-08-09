{ cabal }:

cabal.mkDerivation (self: {
  pname = "primitive";
  version = "0.3.1";
  sha256 = "1903hx88ax4dgyyx00a0k86jy4mkqrprpn7arfy19dqqyfpb2ikj";
  meta = {
    homepage = "http://code.haskell.org/primitive";
    description = "Wrappers for primitive operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
