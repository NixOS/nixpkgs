{ cabal, HsOpenSSL, HUnit, ioStreams, network, testFramework
, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "openssl-streams";
  version = "1.1.0.1";
  sha256 = "1y3vj17951gz3wlf75j3ph3hlkjbrplrmnbd9rcyiipzv51vy8ym";
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
