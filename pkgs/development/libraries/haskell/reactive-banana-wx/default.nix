{ cabal, cabalMacosx, reactiveBanana, wx, wxcore, buildExamples ? false, executablePath ? null}:

assert buildExamples -> executablePath != null;

cabal.mkDerivation (self:
  let lib = self.stdenv.lib;
  in
  {
  pname = "reactive-banana-wx";
  version = "0.6.0.0";
  sha256 = "1pxcymh6xpmbkbc8i2hvjbki9s81mx69wrp8nl1i0y4pppzi8ihp";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ cabalMacosx reactiveBanana wx wxcore ] ++ lib.optional buildExamples executablePath;
  configureFlags = lib.optionalString buildExamples "-fbuildExamples";
  meta = {
    homepage = "http://haskell.org/haskellwiki/Reactive-banana";
    description = "Examples for the reactive-banana library, using wxHaskell";
    license = lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
