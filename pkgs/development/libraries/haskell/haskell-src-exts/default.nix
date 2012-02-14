{ cabal, Cabal, cpphs, happy }:

cabal.mkDerivation (self: {
  pname = "haskell-src-exts";
  version = "1.11.1";
  sha256 = "1jqf8l81zw7x5ryf8h2n0b2636yhxkfp3j4ndbqw6hc7i5q581m6";
  buildDepends = [ Cabal cpphs ];
  buildTools = [ happy ];
  meta = {
    homepage = "http://code.haskell.org/haskell-src-exts";
    description = "Manipulating Haskell source: abstract syntax, lexer, parser, and pretty-printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
