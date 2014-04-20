{ cabal, cpphs, filepath, happy, smallcheck, tasty, tastyHunit
, tastySmallcheck
}:

cabal.mkDerivation (self: {
  pname = "haskell-src-exts";
  version = "1.14.0.1";
  sha256 = "1bsqjj4hy8mqprs44yfy1c96678w9q708yc40g5ygqfyhg0hd29s";
  buildDepends = [ cpphs ];
  testDepends = [
    filepath smallcheck tasty tastyHunit tastySmallcheck
  ];
  buildTools = [ happy ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/haskell-suite/haskell-src-exts";
    description = "Manipulating Haskell source: abstract syntax, lexer, parser, and pretty-printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
