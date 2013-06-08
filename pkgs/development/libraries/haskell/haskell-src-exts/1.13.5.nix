{ cabal, cpphs, happy }:

cabal.mkDerivation (self: {
  pname = "haskell-src-exts";
  version = "1.13.5";
  sha256 = "03bzhfp7l9f5hh61qdrr83331nbfgj3jfsfylwmnmcknpisdqnkw";
  buildDepends = [ cpphs ];
  buildTools = [ happy ];
  doCheck = false;
  meta = {
    homepage = "http://code.haskell.org/haskell-src-exts";
    description = "Manipulating Haskell source: abstract syntax, lexer, parser, and pretty-printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
