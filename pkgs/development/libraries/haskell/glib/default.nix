{ cabal, Cabal, glib, gtk2hsBuildtools, libc, pkgconfig }:

cabal.mkDerivation (self: {
  pname = "glib";
  version = "0.12.2";
  sha256 = "0p1d6j23yf30824q5gn7pw7s47hs4rnaqs69d2hn2pnzpc1ml3c6";
  buildDepends = [ Cabal ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ glib ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the GLIB library for Gtk2Hs";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
