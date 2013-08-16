{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-bytestring";
  version = "0.3.6";
  sha256 = "0m2ndw6r88vb4cqdkd8jg8dlk9h99mp3rand5j1gxxdjfv7q63ap";
  meta = {
    homepage = "http://code.haskell.org/~wren/";
    description = "Unix/Posix-specific functions for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
