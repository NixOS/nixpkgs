{ cabal, conduit, fastLogger, monadControl, mtl, resourcet, text
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.3.1.1";
  sha256 = "11qqmflcydjfm5py7rkbi9qd0mkhw4kxzxff95wf0jmaia9knvx6";
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
