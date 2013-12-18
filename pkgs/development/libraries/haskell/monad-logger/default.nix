{ cabal, conduit, fastLogger, liftedBase, monadControl, monadLoops
, mtl, resourcet, stm, stmChans, text, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "monad-logger";
  version = "0.3.3.1";
  sha256 = "1amihx9jl42w7sm01ihnldvgv9cilg89im7gr9l0x2f6q4nbhbl2";
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
