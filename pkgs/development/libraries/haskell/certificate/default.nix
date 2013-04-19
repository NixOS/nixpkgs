{ cabal, asn1Data, cryptohash, cryptoPubkeyTypes, filepath, mtl
, pem, time
}:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.3.6";
  sha256 = "1w7xndslapy4ycgf2xshgx90i3v04nsck9l2mzc74nrnwm817b2m";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    asn1Data cryptohash cryptoPubkeyTypes filepath mtl pem time
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/vincenthz/hs-certificate";
    description = "Certificates and Key Reader/Writer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
