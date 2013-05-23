{ cabal, glib, gtk2hsBuildtools, libc, pkgconfig }:

cabal.mkDerivation (self: {
  pname = "glib";
  version = "0.12.4";
  sha256 = "0s92phy1xlgjzqc7y5plviipb98m13h5lj4n9g6lbv4i106z97ax";
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ glib ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the GLIB library for Gtk2Hs";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
