{ cabal, blazeBuilder, conduit, fastLogger, liftedBase
, monadControl, monadLoops, mtl, resourcet, stm, stmChans, text
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.3.4.0";
  sha256 = "16nrzms87klbs26rbaw4j8xal5k7glpbhg7r2x1m3gxbdhsp696n";
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
