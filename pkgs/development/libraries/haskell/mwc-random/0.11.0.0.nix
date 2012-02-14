{ cabal, Cabal, primitive, time, vector }:

cabal.mkDerivation (self: {
  pname = "mwc-random";
  version = "0.11.0.0";
  sha256 = "1yqi472m3snx71fvd4mig6my74rkpf3sbsdcmx2y2l00cyk79ghh";
  buildDepends = [ Cabal primitive time vector ];
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
