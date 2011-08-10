{ cabal, alex, happy }:

cabal.mkDerivation (self: {
  pname = "gtk2hs-buildtools";
  version = "0.12.0";
  sha256 = "1czlmyr9zhzc0h1j0z3chv06ma77cibq2yc6h1slfphb1lkv66a8";
  isLibrary = false;
  isExecutable = true;
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://www.haskell.org/gtk2hs/";
    description = "Tools to build the Gtk2Hs suite of User Interface libraries.";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
