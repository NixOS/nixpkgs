{ cabal, conduit, fastLogger, monadControl, mtl, resourcet, text
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.2.3.2";
  sha256 = "0b5jfmzmsb7pdawcm5i74sy934q2d78pjs39invas502kx5bxzk5";
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
