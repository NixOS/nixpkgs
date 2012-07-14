{ cabal, alex, filepath, happy, random }:

cabal.mkDerivation (self: {
  pname = "gtk2hs-buildtools";
  version = "0.12.3.1";
  sha256 = "0a5lay1zy1pi6inaqjvhn8v0by2z5dpy3dssqsxwbq2hkfxizzy6";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath random ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Tools to build the Gtk2Hs suite of User Interface libraries";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
