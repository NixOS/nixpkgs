{ cabal, conduit, fastLogger, liftedBase, monadControl, monadLoops
, mtl, resourcet, stm, stmChans, text, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.3.2.0";
  sha256 = "0pgjayx6h1zqadqrzaf36070kir7qlinha9h4bf532lfx5yc1yxg";
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
