{ cabal, glib, gtk, x11 }:

cabal.mkDerivation (self: {
  pname = "gtk-traymanager";
  version = "0.1.3";
  sha256 = "07671f3j3r07djgvrlpbdaqqnm2yc7sc5f5isjn5nczrwh8n0sj4";
  buildDepends = [ glib gtk ];
  pkgconfigDepends = [ gtk x11 ];
  meta = {
    homepage = "http://github.com/travitch/gtk-traymanager";
    description = "A wrapper around the eggtraymanager library for Linux system trays";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
  };
})
