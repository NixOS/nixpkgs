{ cabal, fastLogger, resourcet, text, transformers }:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.2.0.1";
  sha256 = "151brb5h92xc0mhfqcapmxib7vh2k36rsw493fxbn3256xkzc8gk";
  buildDepends = [ fastLogger resourcet text transformers ];
  meta = {
    homepage = "https://github.com/kazu-yamamoto/logger";
    description = "A class of monads which can log messages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
