{ fetchurl, stdenv, guile, guile_lib, gwrap
, pkgconfig, gconf, glib, gnome_vfs, gtk
, libglade, libgnome, libgnomecanvas, libgnomeui
, pango, guileCairo, autoconf, automake, texinfo }:

stdenv.mkDerivation rec {
  name = "${pkg-name}-platform-20150123";
  pkgName = "guile-gnome";
  commit = "0fcbe69797b9501b8f1283a78eb92bf43b08d080";
  savannah = "http://git.savannah.gnu.org/cgit";
  
  src = fetchurl {
    url = "${savannah}/${pkgName}.git/snapshot/${pkgName}-${commit}.tar.gz";
    sha256 = "1jhpgi7hf7pms4hqlgi97zsxsx8q9kn488mz3hjhb56yyyivxlvp";
  };
  
  buildInputs = [
    autoconf
    automake
    texinfo
    guile
    gwrap
    pkgconfig
    gconf
    glib
    gnome_vfs
    gtk
    libglade
    libgnome
    libgnomecanvas
    libgnomeui
    pango
    guileCairo
  ] ++ stdenv.lib.optional doCheck guile_lib;

  preConfigure = ''
      ./autogen.sh
  '';

  # The test suite tries to open an X display, which fails.
  doCheck = false;

  meta = {
    description = "GNOME bindings for GNU Guile";

    longDescription =
      '' GNU guile-gnome brings the power of Scheme to your graphical
         application.  guile-gnome modules support the entire Gnome library
         stack: from Pango to GnomeCanvas, Gtk+ to GStreamer, Glade to
         GtkSourceView, you will find in guile-gnome a comprehensive
         environment for developing modern applications.
      '';

    homepage = http://www.gnu.org/software/guile-gnome/;

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.taktoa ];
  };
}
