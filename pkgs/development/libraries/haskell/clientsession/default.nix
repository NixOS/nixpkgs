{ cabal, base64Bytestring, cereal, cipherAes, cprngAes, cryptoApi
, entropy, skein, tagged
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.8.1";
  sha256 = "1x4qfm4hkvm3xmn7hnvcx1j900g97qhks66xzik1wvsjy3piwpgd";
  buildDepends = [
    base64Bytestring cereal cipherAes cprngAes cryptoApi entropy skein
    tagged
  ];
  meta = {
    homepage = "http://github.com/yesodweb/clientsession/tree/master";
    description = "Securely store session data in a client-side cookie";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
