{ cabal, cabalMacosx, reactiveBanana, wx, wxcore }:

cabal.mkDerivation (self: {
  pname = "reactive-banana-wx";
  version = "0.7.0.0";
  sha256 = "06qln09d57l084nvh1js3k6074vl8yzih5kwfpp43gsy8in2dspx";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ cabalMacosx reactiveBanana wx wxcore ];
  configureFlags = "-f-buildExamples";
  meta = {
    homepage = "http://haskell.org/haskellwiki/Reactive-banana";
    description = "Examples for the reactive-banana library, using wxHaskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
