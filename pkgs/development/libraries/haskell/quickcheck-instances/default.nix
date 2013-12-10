{ cabal, QuickCheck, text, time }:

cabal.mkDerivation (self: {
  pname = "quickcheck-instances";
  version = "0.3.4";
  sha256 = "10kkjqn530cd4bz5jfnvfvpswk25glyjnmy21qj253db6ja8xns1";
  buildDepends = [ QuickCheck text time ];
  meta = {
    homepage = "https://github.com/aslatter/qc-instances";
    description = "Common quickcheck instances";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
