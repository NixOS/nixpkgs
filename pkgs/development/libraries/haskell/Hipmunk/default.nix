{ cabal, StateVar, transformers }:

cabal.mkDerivation (self: {
  pname = "Hipmunk";
  version = "5.2.0.14";
  sha256 = "1jzsalib2y6r4aw7d10v3pgapmnj1knvq3fyad3w5d11qmvx9zwc";
  buildDepends = [ StateVar transformers ];
  meta = {
    homepage = "https://github.com/meteficha/Hipmunk";
    description = "A Haskell binding for Chipmunk";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
