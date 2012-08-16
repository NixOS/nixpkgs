{ cabal, base64Bytestring, cereal, cprngAes, cryptoApi
, cryptocipher, entropy, skein, tagged
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.8.0";
  sha256 = "1ypd5ki4lvwriw922p65hmj41sargawah1gnwi0q08vc7iagq64k";
  buildDepends = [
    base64Bytestring cereal cprngAes cryptoApi cryptocipher entropy
    skein tagged
  ];
  meta = {
    homepage = "http://github.com/yesodweb/clientsession/tree/master";
    description = "Securely store session data in a client-side cookie";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
