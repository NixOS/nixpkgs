{ cabal, StateVar, transformers }:

cabal.mkDerivation (self: {
  pname = "Hipmunk";
  version = "5.2.0.13";
  sha256 = "0ddf7cbwaswyszq9rs5jq353npbry8l2cc7p5wq9wq97yplz10bc";
  buildDepends = [ StateVar transformers ];
  meta = {
    homepage = "https://github.com/meteficha/Hipmunk";
    description = "A Haskell binding for Chipmunk";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
