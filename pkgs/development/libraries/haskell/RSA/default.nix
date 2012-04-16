{ cabal, binary, cryptoApi, monadcryptorandom, pureMD5, SHA }:

cabal.mkDerivation (self: {
  pname = "RSA";
  version = "1.2.0.0";
  sha256 = "0x4wa0yq4k43ccdakqcmy0mxvdlvrkfg6kc1j2hv7hh8b4vjisms";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary cryptoApi monadcryptorandom pureMD5 SHA ];
  meta = {
    description = "Implementation of RSA, using the padding schemes of PKCS#1 v2.1.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
