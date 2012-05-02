{ cabal, certificate, cryptoApi, cryptocipher, cryptohash, mtl
, network, pem, text, time, tls, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.4.6";
  sha256 = "1xl55i4nr7kyc3qxi8zmq18m0xhlwlrx9fwkck22krshqgq2i6nn";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    certificate cryptoApi cryptocipher cryptohash mtl network pem text
    time tls vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls-extra";
    description = "TLS extra default values and helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
