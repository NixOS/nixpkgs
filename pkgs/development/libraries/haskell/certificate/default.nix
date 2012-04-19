{ cabal, asn1Data, cryptoPubkeyTypes, mtl, pem, time }:

cabal.mkDerivation (self: {
  pname = "certificate";
  version = "1.2.1";
  sha256 = "0lhw38jqkiw7dwckwcqwmsi9br1insb5dp8wajcpgas6xn6cy2qy";
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
