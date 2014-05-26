{ cabal, HsOpenSSL, HUnit, ioStreams, network, testFramework
, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "openssl-streams";
  version = "1.1.0.2";
  sha256 = "0h3jxxdls0p1xxr02rfag7j9y13ll3xgzx2ldv1nsfcv3rzw2pfy";
  buildDepends = [ HsOpenSSL ioStreams network ];
  testDepends = [
    HsOpenSSL HUnit ioStreams network testFramework testFrameworkHunit
  ];
  jailbreak = true;
  meta = {
    description = "OpenSSL network support for io-streams";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
