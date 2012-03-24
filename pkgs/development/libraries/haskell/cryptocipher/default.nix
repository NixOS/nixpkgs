{ cabal, cereal, cryptoApi, cryptoPubkeyTypes, primitive, tagged
, vector
}:

cabal.mkDerivation (self: {
  pname = "cryptocipher";
  version = "0.3.0";
  sha256 = "17jbzssdbprspadz5ynyam60l5iw7s809irklfg1ii89x26mlyix";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cereal cryptoApi cryptoPubkeyTypes primitive tagged vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptocipher";
    description = "Symmetrical Block, Stream and PubKey Ciphers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
