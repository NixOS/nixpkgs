{ fetchurl, stdenv, pkgconfig, glib, gtk, cairo, clutter, sqlite
, clutter_gtk, libsoup /*, libmenphis */ }:

stdenv.mkDerivation rec {
  name = "libchamplain-0.6.1";

  src = fetchurl {
    url = "http://download.gnome.org/sources/libchamplain/0.6/${name}.tar.gz";
    sha256 = "1l1in4khnral157j46aq2d26nviz23icnm353587vcwjhdbw86sg";
  };

  buildInputs = [ pkgconfig ];

  # These all appear in `champlain{,-gtk}-0.6.pc'.
  propagatedBuildInputs =
    [ glib gtk cairo clutter clutter_gtk sqlite libsoup ];

  meta = {
    homepage = http://projects.gnome.org/libchamplain/;
    license = "LGPLv2+";

    description = "libchamplain, a C library providing a ClutterActor to display maps";

    longDescription =
      '' libchamplain is a C library providing a ClutterActor to display
         maps.  It also provides a Gtk+ widget to display maps in Gtk+
         applications.  Python and Perl bindings are also available.  It
         supports numerous free map sources such as OpenStreetMap,
         OpenCycleMap, OpenAerialMap, and Maps for free.
      '';

     maintainers = [ stdenv.lib.maintainers.ludo ];
     platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
