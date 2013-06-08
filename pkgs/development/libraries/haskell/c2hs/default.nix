{ cabal, filepath, languageC }:

cabal.mkDerivation (self: {
  pname = "c2hs";
  version = "0.16.4";
  sha256 = "0m8mzc19cgaqsi1skqimk22770xddxx0j024mgp76hl8vqc5rcgi";
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
