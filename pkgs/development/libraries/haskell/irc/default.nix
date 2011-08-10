{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "irc";
  version = "0.4.4.2";
  sha256 = "1bbxlmb6jzz0zw18nr3d6lgd83vi9hrjahfcf1dswc946wi31s97";
  buildDepends = [ parsec ];
  meta = {
    description = "A small library for parsing IRC messages.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
