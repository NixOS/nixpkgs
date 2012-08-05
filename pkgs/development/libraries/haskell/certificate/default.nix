{ cabal, asn1Data, cryptoPubkeyTypes, mtl, pem, time }:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.2.4";
  sha256 = "079364567cshfj2bc0lbj933jcgdqisvv8m0czlyscb4hd10vfg7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ asn1Data cryptoPubkeyTypes mtl pem time ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-certificate";
    description = "Certificates and Key Reader/Writer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
