{ cabal, glib, gtk2hsBuildtools, libc, pkgconfig }:

cabal.mkDerivation (self: {
  pname = "glib";
  version = "0.12.1";
  sha256 = "0lsgpbd08w64npc0xsnxg8n4vj2hdnjvs55h4lhgc61p05q9gv52";
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
