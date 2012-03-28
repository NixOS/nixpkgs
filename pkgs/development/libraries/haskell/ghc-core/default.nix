{ cabal, colorizeHaskell, filepath, pcreLight }:

cabal.mkDerivation (self: {
  pname = "ghc-core";
  version = "0.5.4";
  sha256 = "1s68m2zkpz0n927rgzg0l0r5v8pk3z03rlkd82h83agw0hzb9ng7";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ colorizeHaskell filepath pcreLight ];
  meta = {
    homepage = "http://code.haskell.org/~dons/code/ghc-core";
    description = "Display GHC's core and assembly output in a pager";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
