{ cabal, conduit, fastLogger, liftedBase, monadControl, monadLoops
, mtl, resourcet, stm, stmChans, text, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.3.3.2";
  sha256 = "0s75q974q6jwp89xj5kkqziy4crm9484dqvrpgd8ms7rw613jjz6";
  buildDepends = [
    conduit fastLogger liftedBase monadControl monadLoops mtl resourcet
    stm stmChans text transformers transformersBase
  ];
  meta = {
    homepage = "https://github.com/kazu-yamamoto/logger";
    description = "A class of monads which can log messages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
