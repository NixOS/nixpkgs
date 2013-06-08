{ cabal, asn1Data, cryptohash, cryptoPubkeyTypes, filepath, mtl
, pem, time
}:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.3.8";
  sha256 = "1id3jfaisl04n1mjj9lbq3gyz8hyn3r9p9chzmfbra0pcj3vf1m0";
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
