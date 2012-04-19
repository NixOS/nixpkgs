{ cabal, cpphs, happy }:

cabal.mkDerivation (self: {
  pname = "haskell-src-exts";
  version = "1.13.2";
  sha256 = "1vq4qagbypm8lp4dr6zjd6mhgiv096a2cpyfvfs3yq06iqv5x602";
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
