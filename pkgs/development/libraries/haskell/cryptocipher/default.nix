{cabal, cereal, cryptoApi, primitive, tagged, vector} :

cabal.mkDerivation (self : {
  pname = "cryptocipher";
  version = "0.2.14";
  sha256 = "1r91d9sqc53c628z378fyah7vvmkakvxpwbslam0yhfgp2p0l23z";
  propagatedBuildInputs = [
    cereal cryptoApi primitive tagged vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptocipher";
    description = "Symmetrical Block, Stream and PubKey Ciphers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
