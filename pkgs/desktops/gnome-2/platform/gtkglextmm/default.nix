{ stdenv, fetchurl_gnome, pkgconfig, gtkglext, gtkmm, gtk, mesa, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "gtkglextmm";
    major = "1"; minor = "2"; patchlevel = "0"; extension = "bz2";
    sha256 = "6cd4bd2a240e5eb1e3a24c5a3ebbf7ed905b522b888439778043fdeb58771fea";
  };

  patches = [ ./gdk.patch ];

  buildNativeInputs = [pkgconfig];

  propagatedBuildInputs = [ gtkglext gtkmm gtk mesa gdk_pixbuf ];

  meta = {
    description = "C++ wrappers for GtkGLExt";

    license = "LGPLv2+";

    platforms = stdenv.lib.platforms.linux;
  };
}
