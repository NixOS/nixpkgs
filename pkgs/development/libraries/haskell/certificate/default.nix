{ cabal, asn1Data, cryptoPubkeyTypes, mtl, pem, time }:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.2.2";
  sha256 = "0qwx0y534fa5p2wzxd5q2bvcsvmmvmy45rwzj01g6zyjzmx2rnsb";
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
