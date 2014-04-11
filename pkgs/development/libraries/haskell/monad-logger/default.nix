{ cabal, blazeBuilder, conduit, conduitExtra, exceptions
, fastLogger, liftedBase, monadControl, monadLoops, mtl, resourcet
, stm, stmChans, text, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.3.6";
  sha256 = "0a3dbk3c1jv8zbxrb5vzf5ypwwzkamxd35rm8pjn13aqcnnznniq";
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
