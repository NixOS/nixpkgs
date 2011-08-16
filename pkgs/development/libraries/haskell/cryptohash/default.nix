{ cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "cryptohash";
  version = "0.7.1";
  sha256 = "1bblhqidzb8b75fk9zb1ibdssmbh1kaq20q144c9y1cas3gbn6h3";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ cereal cryptoApi tagged ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptohash";
    description = "collection of crypto hashes, fast, pure and practical";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
