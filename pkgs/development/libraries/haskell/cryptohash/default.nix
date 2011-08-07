{cabal, cereal, cryptoApi, tagged} :

cabal.mkDerivation (self : {
  pname = "cryptohash";
  version = "0.7.0";
  sha256 = "1vlyy8licdfr2nggjasikrkl209x1cyzcz4mjm5n22f7fwyqh4nm";
  propagatedBuildInputs = [ cereal cryptoApi tagged ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptohash";
    description = "collection of crypto hashes, fast, pure and practical";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
