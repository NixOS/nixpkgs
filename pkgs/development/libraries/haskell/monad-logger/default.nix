{ cabal, blazeBuilder, conduit, conduitExtra, exceptions
, fastLogger, liftedBase, monadControl, monadLoops, mtl, resourcet
, stm, stmChans, text, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.3.6.1";
  sha256 = "0ylsrhp2a9qir03nmmz6rkim149pw1fgm63lfg611gvh598ig6ss";
  buildDepends = [
    blazeBuilder conduit conduitExtra exceptions fastLogger liftedBase
    monadControl monadLoops mtl resourcet stm stmChans text
    transformers transformersBase
  ];
  meta = {
    homepage = "https://github.com/kazu-yamamoto/logger";
    description = "A class of monads which can log messages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
