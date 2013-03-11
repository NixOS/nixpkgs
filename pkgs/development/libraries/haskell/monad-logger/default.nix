{ cabal, conduit, fastLogger, monadControl, mtl, resourcet, text
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.3.1";
  sha256 = "09bgj436hyyc5x0flkwcxx3m97y5pm8whd5cc6a0q7bc4bnzf80j";
  buildDepends = [
    conduit fastLogger monadControl mtl resourcet text transformers
    transformersBase
  ];
  meta = {
    homepage = "https://github.com/kazu-yamamoto/logger";
    description = "A class of monads which can log messages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
