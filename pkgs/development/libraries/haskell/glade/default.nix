{ cabal, Cabal, glib, gtk, gtk2hsBuildtools, gtkC, libc, libglade
, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "glade";
  version = "0.12.1";
  sha256 = "114gdjz6bzfzqm71j17yb5mq96wcvjdv7ig3k4x4d9mdp97w8990";
  buildDepends = [ Cabal glib gtk ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ gtkC libglade ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the glade library";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
