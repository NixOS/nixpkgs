{ cabal, base64Bytestring, cereal, cryptoApi, cryptocipher
, cryptohash
}:

cabal.mkDerivation (self: {
  pname = "clientsession";
  version = "0.7.2";
  sha256 = "0jfpgzfgcmc80qrzxj6dsg6cbd97pscg5yp99c9f58m4igr3fb2q";
  buildDepends = [
    base64Bytestring cereal cryptoApi cryptocipher cryptohash
  ];
  meta = {
    homepage = "http://github.com/snoyberg/clientsession/tree/master";
    description = "Store session data in a cookie";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
