{ cabal, cpphs, happy }:

cabal.mkDerivation (self: {
  pname = "haskell-src-exts";
  version = "1.13.0";
  sha256 = "1kkhv8frvrry9jb38p5xmsqij0wrz88gszz5zcndcmbhkr5d4b64";
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
