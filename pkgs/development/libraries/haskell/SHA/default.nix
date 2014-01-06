{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "SHA";
  version = "1.6.2.1";
  sha256 = "0knzwqgwshr9b0rf8mf6xmgp3qxv4yavg0zy9xz4zmgm5319mvla";
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
