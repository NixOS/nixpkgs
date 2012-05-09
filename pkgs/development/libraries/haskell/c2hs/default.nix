{ cabal, filepath, languageC }:

cabal.mkDerivation (self: {
  pname = "c2hs";
  version = "0.16.3";
  sha256 = "1qqsxfdkf5sfj3mvk265dbng3br9w633y8v1piajqaidki7vwqm5";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath languageC ];
  meta = {
    homepage = "http://www.cse.unsw.edu.au/~chak/haskell/c2hs/";
    description = "C->Haskell FFI tool that gives some cross-language type safety";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
