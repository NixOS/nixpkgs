{ cabal, HsOpenSSL, HUnit, ioStreams, network, testFramework
, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "openssl-streams";
  version = "1.1.0.0";
  sha256 = "0xww3n1mhw0sp9nkx4847gqbq4wnfcnc2m782kn5n8jxnjnm1fqn";
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
