{ cabal, alex, filepath, happy, random }:

cabal.mkDerivation (self: {
  pname = "gtk2hs-buildtools";
  version = "0.12.1";
  sha256 = "003d48q8q6ji4axa69bh0sp95fic19cgw3hwigsjbl46qgh6n9gl";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath random ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Tools to build the Gtk2Hs suite of User Interface libraries";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
