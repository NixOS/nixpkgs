{ cabal, cabalMacosx, reactiveBanana, wx, wxcore }:

cabal.mkDerivation (self: {
  pname = "reactive-banana-wx";
  version = "0.7.1.0";
  sha256 = "06hkb8v6rjpw95vf16xh547igxxzddr6wpjiwhqwpwhz2alavk2v";
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
