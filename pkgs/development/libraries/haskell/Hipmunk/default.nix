{ cabal, StateVar, transformers }:

cabal.mkDerivation (self: {
  pname = "Hipmunk";
  version = "5.2.0.7";
  sha256 = "1cinxhz4qb8xcbygifx85q4zf6pmjwi90v01vqwyvwlfxmbk0j7k";
  buildDepends = [ StateVar transformers ];
  noHaddock = true;
  meta = {
    homepage = "http://patch-tag.com/r/felipe/hipmunk/home";
    description = "A Haskell binding for Chipmunk";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
