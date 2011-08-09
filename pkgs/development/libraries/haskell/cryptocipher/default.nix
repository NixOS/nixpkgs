{ cabal, cereal, cryptoApi, primitive, tagged, vector }:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.2.14";
  sha256 = "1r91d9sqc53c628z378fyah7vvmkakvxpwbslam0yhfgp2p0l23z";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ cereal cryptoApi primitive tagged vector ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptocipher";
    description = "Symmetrical Block, Stream and PubKey Ciphers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
