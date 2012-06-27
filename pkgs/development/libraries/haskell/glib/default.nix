{ cabal, glib, gtk2hsBuildtools, libc, pkgconfig }:

cabal.mkDerivation (self: {
  pname = "glib";
  version = "0.12.3.1";
  sha256 = "1k5s1d05kv0amvkjr644pqvicvmcgr5fffsz0xyljbj5jk4iv0py";
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
