{ cabal, byteable, cryptoCipherTypes, HUnit, mtl, QuickCheck
, securemem, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "crypto-cipher-tests";
  version = "0.0.1";
  sha256 = "1g5rxx07s23pr0vam0bjlp3qwxzqa3m6x6gbv88fhkmbqwxiq2fh";
  buildDepends = [
    byteable cryptoCipherTypes HUnit mtl QuickCheck securemem
    testFramework testFrameworkHunit testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-cipher";
    description = "Generic cryptography cipher tests";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
