{ cabal, glib, gtk2hsBuildtools, libc, pkgconfig }:

cabal.mkDerivation (self: {
  pname = "glib";
  version = "0.12.3";
  sha256 = "1hv7wnxsjzlr2bchl8ir967iv9qjzlv9lnlyvrilagzafr7nximb";
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
