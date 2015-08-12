{ fetchurl, stdenv, pkgconfig, glib, gtk3, cairo, clutter, sqlite
, clutter_gtk, libsoup /*, libmemphis */ }:

stdenv.mkDerivation rec {
  name = "libchamplain-0.12.10";

  src = fetchurl {
    url = "mirror://gnome/sources/libchamplain/0.12/${name}.tar.xz";
    sha256 = "019b8scnx7d3wdylmpk9ihzh06w25b63x9cn8nhj6kjx82rcwlxz";
  };

  buildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ glib gtk3 cairo clutter_gtk sqlite libsoup ];

  meta = {
    homepage = http://projects.gnome.org/libchamplain/;
    license = stdenv.lib.licenses.lgpl2Plus;

    description = "C library providing a ClutterActor to display maps";

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
