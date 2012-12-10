{ cabal, conduit, fastLogger, monadControl, mtl, resourcet, text
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.2.3.1";
  sha256 = "15f85cf1nsy3xbjgikrn8cr09r70h8n2c67bpbxnfjna3ak94gkn";
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
