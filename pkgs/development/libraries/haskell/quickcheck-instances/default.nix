{ cabal, QuickCheck, text, time }:

cabal.mkDerivation (self: {
  pname = "quickcheck-instances";
  version = "0.3.3";
  sha256 = "0l5rck5sh3cplqqkkasm00phy962y3wa9l8a44843grp3flnpv72";
  buildDepends = [ QuickCheck text time ];
  meta = {
    homepage = "https://github.com/aslatter/qc-instances";
    description = "Common quickcheck instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
