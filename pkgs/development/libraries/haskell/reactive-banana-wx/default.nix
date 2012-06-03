{ cabal, cabalMacosx, reactiveBanana, wx, wxcore }:

cabal.mkDerivation (self: {
  pname = "reactive-banana-wx";
  version = "0.6.0.0";
  sha256 = "1pxcymh6xpmbkbc8i2hvjbki9s81mx69wrp8nl1i0y4pppzi8ihp";
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
