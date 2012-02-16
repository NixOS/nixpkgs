{ cabal, base64Bytestring, Cabal, cereal, cprngAes, cryptoApi
, cryptocipher, entropy, skein, tagged
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.7.4";
  sha256 = "050mg3rzyld4v2b9v1pc1q563sp7sffiapvr8ks8f46ibl17lvss";
  buildDepends = [
    base64Bytestring Cabal cereal cprngAes cryptoApi cryptocipher
    entropy skein tagged
  ];
  meta = {
    homepage = "http://github.com/yesodweb/clientsession/tree/master";
    description = "Securely store session data in a client-side cookie";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
