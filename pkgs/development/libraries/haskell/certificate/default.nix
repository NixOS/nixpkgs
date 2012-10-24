{ cabal, asn1Data, cryptohash, cryptoPubkeyTypes, filepath, mtl
, pem, time
}:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.3.0";
  sha256 = "1vhqbwbk0xpq74f01lkqifq7pgxdbfgq193gy57b9rwsnxvzqip1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    asn1Data cryptohash cryptoPubkeyTypes filepath mtl pem time
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-certificate";
    description = "Certificates and Key Reader/Writer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
