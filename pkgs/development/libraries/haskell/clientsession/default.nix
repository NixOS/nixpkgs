{ cabal, base64Bytestring, cereal, cryptoApi, cryptocipher, skein
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.7.3.2";
  sha256 = "1ml1f5sarfck39qrv4zjcbk1vwgazn32gnjm78fm047ixczi9340";
  buildDepends = [
    base64Bytestring cereal cryptoApi cryptocipher skein
  ];
  meta = {
    homepage = "http://github.com/snoyberg/clientsession/tree/master";
    description = "Securely store session data in a client-side cookie";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
