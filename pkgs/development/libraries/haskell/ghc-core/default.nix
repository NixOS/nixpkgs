{ cabal, colorizeHaskell, filepath, pcreLight }:

cabal.mkDerivation (self: {
  pname = "ghc-core";
  version = "0.5.6";
  sha256 = "11byidxq2mcqams9a7df0hwwlzir639mr1s556sw5rrbi7jz6d7c";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ colorizeHaskell filepath pcreLight ];
  meta = {
    homepage = "https://github.com/shachaf/ghc-core";
    description = "Display GHC's core and assembly output in a pager";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
