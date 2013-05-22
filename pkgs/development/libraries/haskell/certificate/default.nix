{ cabal, asn1Data, cryptohash, cryptoPubkeyTypes, filepath, mtl
, pem, time
}:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.3.7";
  sha256 = "06sfka5p381gayx2q7vvyr7dl8q8d4jfqdrys3k0z8fjxdbqrqya";
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
