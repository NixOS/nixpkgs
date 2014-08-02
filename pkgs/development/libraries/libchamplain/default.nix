{ fetchurl, stdenv, pkgconfig, glib, gtk3, cairo, clutter, sqlite
, clutter_gtk, libsoup /*, libmemphis */ }:

stdenv.mkDerivation rec {
  name = "libchamplain-0.12.2";

  src = fetchurl {
    url = mirror://gnome/sources/libchamplain/0.12/libchamplain-0.12.2.tar.xz;
    sha256 = "0bkyzm378gh6qs7grr2vgzrl4z1pi99yysy8iwzdqzs0bs3rfgyj";
  };

  buildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ glib gtk3 cairo clutter_gtk sqlite libsoup ];

  configureFlags = [ "--disable-introspection" ]; # not needed anywhere AFAIK

  meta = {
    homepage = http://projects.gnome.org/libchamplain/;
    license = stdenv.lib.licenses.lgpl2Plus;

    description = "libchamplain, a C library providing a ClutterActor to display maps";

    longDescription =
      '' libchamplain is a C library providing a ClutterActor to display
         maps.  It also provides a Gtk+ widget to display maps in Gtk+
         applications.  Python and Perl bindings are also available.  It
         supports numerous free map sources such as OpenStreetMap,
         OpenCycleMap, OpenAerialMap, and Maps for free.
      '';

     maintainers = [ ];
     platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
