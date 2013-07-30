{ cabal, StateVar, transformers }:

cabal.mkDerivation (self: {
  pname = "Hipmunk";
  version = "5.2.0.11";
  sha256 = "0pcbwlq0njgj6dzh8h94gml63wv52f6l9hdas378lm7v8gbizxl7";
  buildDepends = [ StateVar transformers ];
  meta = {
    homepage = "http://patch-tag.com/r/felipe/hipmunk/home";
    description = "A Haskell binding for Chipmunk";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
