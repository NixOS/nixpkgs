{ cabal, QuickCheck, text, time }:

cabal.mkDerivation (self: {
  pname = "quickcheck-instances";
  version = "0.3.5";
  sha256 = "1ak55d3yi6ii01921zihn8mk12mws78w05gmhk766kpylhhgni5f";
  buildDepends = [ QuickCheck text time ];
  meta = {
    homepage = "https://github.com/aslatter/qc-instances";
    description = "Common quickcheck instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
