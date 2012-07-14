{ cabal, asn1Data, cryptoPubkeyTypes, mtl, pem, time }:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.2.3";
  sha256 = "0xn46327a50vj70d26gc4z2rn4l6qk77j7mkdwg1j2yh6mcn0n7a";
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
