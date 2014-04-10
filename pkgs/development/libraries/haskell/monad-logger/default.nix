{ cabal, blazeBuilder, conduit, exceptions, fastLogger, liftedBase
, monadControl, monadLoops, mtl, resourcet, stm, stmChans, text
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.3.5.1";
  sha256 = "0kc23y1l3ja2ym0pr19kcm8aiv8g8skh24p9i3vm74chadsn81pv";
  buildDepends = [
    blazeBuilder conduit exceptions fastLogger liftedBase monadControl
    monadLoops mtl resourcet stm stmChans text transformers
    transformersBase
  ];
  meta = {
    homepage = "https://github.com/kazu-yamamoto/logger";
    description = "A class of monads which can log messages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
