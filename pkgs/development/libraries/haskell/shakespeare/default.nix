{ cabal, parsec, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "1.0.1.4";
  sha256 = "01gw31g75v8r8hjvkv7mxvx7736ib9x9nqpxavpbrfplyxgk2y31";
  buildDepends = [ parsec text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
