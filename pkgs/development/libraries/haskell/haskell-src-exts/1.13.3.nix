{ cabal, cpphs, happy }:

cabal.mkDerivation (self: {
  pname = "haskell-src-exts";
  version = "1.13.3";
  sha256 = "0z2vs6ji0dgm3c11jwcq5jcnjr8a6pawrkn3c8a3a5p612v8d495";
  buildDepends = [ cpphs ];
  buildTools = [ happy ];
  meta = {
    homepage = "http://code.haskell.org/haskell-src-exts";
    description = "Manipulating Haskell source: abstract syntax, lexer, parser, and pretty-printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
