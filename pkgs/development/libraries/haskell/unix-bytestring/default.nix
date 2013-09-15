{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-bytestring";
  version = "0.3.7";
  sha256 = "1qwgs2bwga057csfa8izq0kc5vwi2vcaz2snlcgp0h9vql3qmvrg";
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Unix/Posix-specific functions for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
