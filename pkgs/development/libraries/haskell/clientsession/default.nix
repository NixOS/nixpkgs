{ cabal, base64Bytestring, cereal, cprngAes, cryptoApi
, cryptocipher, entropy, skein, tagged
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.8.0.2";
  sha256 = "189v030g23lvky4vccdaw3p0p6drn26zly80a8n9bbn7b8kbfh4r";
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
