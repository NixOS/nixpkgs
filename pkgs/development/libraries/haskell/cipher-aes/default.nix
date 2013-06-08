{ cabal, QuickCheck, testFramework, testFrameworkQuickcheck2 }:

cabal.mkDerivation (self: {
  pname = "cipher-aes";
  version = "0.1.8";
  sha256 = "171mj9abm0x9bg6mf225mhb25i7xh4v5la5866llb1qrrpvsk1xf";
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cipher-aes";
    description = "Fast AES cipher implementation with advanced mode of operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
