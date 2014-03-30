{ cabal, blazeBuilder, conduit, fastLogger, liftedBase
, monadControl, monadLoops, mtl, resourcet, stm, stmChans, text
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.3.4.1";
  sha256 = "1i5192060svqhc1iv215b98hah6p29bzdqin6ng5qpq8d44hdnpm";
  buildDepends = [
    blazeBuilder conduit fastLogger liftedBase monadControl monadLoops
    mtl resourcet stm stmChans text transformers transformersBase
  ];
  meta = {
    homepage = "https://github.com/kazu-yamamoto/logger";
    description = "A class of monads which can log messages";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
