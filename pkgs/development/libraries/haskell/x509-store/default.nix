{ cabal, asn1Encoding, asn1Types, cryptoPubkeyTypes, filepath, mtl
, pem, time, x509
}:

cabal.mkDerivation (self: {
  pname = "x509-store";
  version = "1.4.3";
  sha256 = "1px5r5y4vaxx479d4av333g1sc03mz1aalpvwwkbi5bwnxydvf01";
  buildDepends = [
    asn1Encoding asn1Types cryptoPubkeyTypes filepath mtl pem time x509
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-certificate";
    description = "X.509 collection accessing and storing methods";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
