{ cabal, asn1Data, cryptohash, cryptoPubkeyTypes, filepath, mtl
, pem, time
}:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.3.3";
  sha256 = "043xj3xd6cfnbg9hw2f8agckww3fasvraa72jw84zqc7l2gq0rq2";
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
