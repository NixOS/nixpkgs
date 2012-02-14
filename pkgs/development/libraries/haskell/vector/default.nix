{ cabal, Cabal, primitive }:

cabal.mkDerivation (self: {
  pname = "vector";
  version = "0.9.1";
  sha256 = "1m6p9dy48fwh2y21y7r6svhzs86a1yijkjil7ch1mdn86gv0f9as";
  buildDepends = [ Cabal primitive ];
  meta = {
    homepage = "http://code.haskell.org/vector";
    description = "Efficient Arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
