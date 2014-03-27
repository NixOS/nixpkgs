{ cabal, hashable, QuickCheck, text, time, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "quickcheck-instances";
  version = "0.3.7";
  sha256 = "0zf2b2zisfx7j7i4jnb79w5hhk5dy53w23fi876flx3vl6mfvszw";
  buildDepends = [
    hashable QuickCheck text time unorderedContainers
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/aslatter/qc-instances";
    description = "Common quickcheck instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
