{ cabal, parsec, shakespeare, text, transformers }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "1.0.2";
  sha256 = "02sk9ql357ybj1h5a4xjn06di5zdafibabhy32j5vs9kpyamvck3";
  buildDepends = [ parsec shakespeare text transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into css at compile time";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
