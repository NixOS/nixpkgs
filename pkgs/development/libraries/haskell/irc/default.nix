{ cabal, parsec }:

cabal.mkDerivation (self: {
  pname = "irc";
  version = "0.5.1.0";
  sha256 = "1xkgqcjxlxqg60qlv26ypmvf9x288sjz1n47rb7zfvjhdimws8gj";
  buildDepends = [ parsec ];
  meta = {
    description = "A small library for parsing IRC messages";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
