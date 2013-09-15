{ cabal, cpphs, filepath, happy, smallcheck, tasty, tastyHunit
, tastySmallcheck
}:

cabal.mkDerivation (self: {
  pname = "haskell-src-exts";
  version = "1.14.0";
  sha256 = "070khsw56xwyrclamv5wckj9na2xbzibv702xx52ik2wbs21dr0d";
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
