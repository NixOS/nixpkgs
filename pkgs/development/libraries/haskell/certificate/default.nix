{ cabal, asn1Data, cryptoPubkeyTypes, mtl, pem, time }:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.2.6";
  sha256 = "1li65r4zbff7r7p533p5xw2z3rd0xnlb2bbwqdldrnswy4mvlakx";
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
