{ cabal, glib, gtk2hsBuildtools, libc, pkgconfig, utf8String }:

cabal.mkDerivation (self: {
  pname = "glib";
  version = "0.12.5.4";
  sha256 = "1jbqfcsmsghq67lwnk6yifs34lxvh6xfbzxzfryalifb4zglccz6";
  buildDepends = [ utf8String ];
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
