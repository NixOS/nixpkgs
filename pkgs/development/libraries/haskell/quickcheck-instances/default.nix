{ cabal, hashable, QuickCheck, text, time, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "quickcheck-instances";
  version = "0.3.6";
  sha256 = "1vaqwsdgi2mirplzg66zysc1ivjjr0qxyiibsh6j771hxs9qk2pr";
  buildDepends = [
    hashable QuickCheck text time unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/aslatter/qc-instances";
    description = "Common quickcheck instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
