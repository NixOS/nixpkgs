{ cabal, primitive, time, vector }:

cabal.mkDerivation (self: {
  pname = "mwc-random";
  version = "0.10.0.1";
  sha256 = "0mmkl90rf57f2rxg3y2nibd37l9mwr2j4c71bwyvxqzfk7cylw9b";
  buildDepends = [ primitive time vector ];
  meta = {
    homepage = "https://github.com/bos/mwc-random";
    description = "Fast, high quality pseudo random number generation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
