{ cabal, lens, time }:

cabal.mkDerivation (self: {
  pname = "lens-datetime";
  version = "0.2";
  sha256 = "0wrs7alz1zfg1xrg04lhz01mrd1gcz2xr8b5mxfdvq94f5m87sdr";
  buildDepends = [ lens time ];
  meta = {
    homepage = "http://github.com/klao/lens-datetime";
    description = "Lenses for Data.Time.* types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
