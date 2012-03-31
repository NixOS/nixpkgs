{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "SHA";
  version = "1.5.0.1";
  sha256 = "1nyj50hyka2fnk9nnidygl8d52xgvmj9m8aywjzbzdaxxrmdab8g";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary ];
  meta = {
    description = "Implementations of the SHA suite of message digest functions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
