{ cabal, base64Bytestring, binary, cryptohash, random, SHA }:

cabal.mkDerivation (self: {
  pname = "pwstore-fast";
  version = "2.4";
  sha256 = "0n0qw1w7j1h5c1pk2vscwwnxxb4qx2dd73jr5y1rn63gwd0wp171";
  buildDepends = [ base64Bytestring binary cryptohash random SHA ];
  meta = {
    homepage = "https://github.com/PeterScott/pwstore";
    description = "Secure password storage";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
