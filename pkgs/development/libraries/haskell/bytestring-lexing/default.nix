{ cabal, alex }:

cabal.mkDerivation (self: {
  pname = "bytestring-lexing";
  version = "0.2.1";
  sha256 = "0pibn4phfp346i6i8zwic5zlbq9lqa6ifyx6bdl3p5c8jy3v23r9";
  buildTools = [ alex ];
  meta = {
    homepage = "http://code.haskell.org/~dons/code/bytestring-lexing";
    description = "Parse literals efficiently from bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
