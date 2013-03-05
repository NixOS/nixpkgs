{ cabal, certificate, cipherAes, cipherRc4, cryptohash
, cryptoPubkey, cryptoRandomApi, mtl, network, pem, text, time, tls
, vector
}:

cabal.mkDerivation (self: {
  pname = "tls-extra";
  version = "0.6.1";
  sha256 = "0gc3dz3s188jk6q2lai56y4ckxh62s9gm04d7jznr6jzpx2i4fan";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    certificate cipherAes cipherRc4 cryptohash cryptoPubkey
    cryptoRandomApi mtl network pem text time tls vector
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-tls";
    description = "TLS extra default values and helpers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
