{ cabal, StateVar, transformers }:

cabal.mkDerivation (self: {
  pname = "Hipmunk";
  version = "5.2.0.9";
  sha256 = "0c0s5spsyp67ajfzck8f29px2xid8aiws12l3dswvp50d74a9mlq";
  buildDepends = [ StateVar transformers ];
  meta = {
    homepage = "http://patch-tag.com/r/felipe/hipmunk/home";
    description = "A Haskell binding for Chipmunk";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
