{ cabal, Cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "cryptohash";
  version = "0.7.4";
  sha256 = "1nplmwihq40jmng4r3wiyfb0i33a8wx2gmlbqajc62wny98l7sab";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal cereal cryptoApi tagged ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptohash";
    description = "collection of crypto hashes, fast, pure and practical";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
