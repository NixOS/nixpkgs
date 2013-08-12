{ cabal, filepath, languageC }:

cabal.mkDerivation (self: {
  pname = "c2hs";
  version = "0.16.5";
  sha256 = "19h4zppn7ry7p3f7qw1kgsrf6h2bjnknycfrj3ibxys82qpv8m8y";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath languageC ];
  meta = {
    homepage = "https://github.com/haskell/c2hs";
    description = "C->Haskell FFI tool that gives some cross-language type safety";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
