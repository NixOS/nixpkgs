{ cabal, filepath, HUnit, languageC, shelly, testFramework
, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "c2hs";
  version = "0.16.6";
  sha256 = "1yf7mcslkf6m1nizifqva8j5sxnw87bg60dw8mfgpmqvrzpbxizm";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath languageC ];
  testDepends = [
    filepath HUnit shelly testFramework testFrameworkHunit text
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/haskell/c2hs";
    description = "C->Haskell FFI tool that gives some cross-language type safety";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
