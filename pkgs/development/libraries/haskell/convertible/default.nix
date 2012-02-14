{ cabal, Cabal, mtl, text, time }:

cabal.mkDerivation (self: {
  pname = "convertible";
  version = "1.0.11.0";
  sha256 = "0qkz760ddshmglmrf47a01978c9zhxfss44b6vmfkwwfcjb7da2b";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal mtl text time ];
  meta = {
    homepage = "http://hackage.haskell.org/cgi-bin/hackage-scripts/package/convertible";
    description = "Typeclasses and instances for converting between types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
