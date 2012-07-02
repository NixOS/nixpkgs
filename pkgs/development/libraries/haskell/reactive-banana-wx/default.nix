{ cabal, cabalMacosx, reactiveBanana, wx, wxcore }:

cabal.mkDerivation (self: {
  pname = "reactive-banana-wx";
  version = "0.6.0.1";
  sha256 = "1i674jy8fwirq267vwwdyqa4whxfx3r689rxjbrh9hyicqwcrl24";
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
