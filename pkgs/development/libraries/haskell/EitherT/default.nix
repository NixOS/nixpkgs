{ cabal, monadControl, transformers, transformersBase }:

cabal.mkDerivation (self: {
  pname = "EitherT";
  version = "0.2.0";
  sha256 = "1vry479zdq1fw7bd4d373c7wf2gg0aibkyb03710w7z2x86chssw";
  buildDepends = [ monadControl transformers transformersBase ];
  meta = {
    description = "EitherT monad transformer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
