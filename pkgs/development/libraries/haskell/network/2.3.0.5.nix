{ cabal, Cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "network";
  version = "2.3.0.5";
  sha256 = "0y1sbgsffzr0skm6xl8907iclgw9vmf395zvpwgakp69i3snh1z0";
  buildDepends = [ Cabal parsec ];
  meta = {
    homepage = "http://github.com/haskell/network";
    description = "Low-level networking interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
