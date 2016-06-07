{ fetchurl, stdenv, pkgconfig, glib, gtk3, cairo, clutter, sqlite
, clutter_gtk, libsoup /*, libmemphis */ }:

let version = "0.12.13"; in
stdenv.mkDerivation rec {
  name = "libchamplain-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libchamplain/0.12/libchamplain-${version}.tar.xz";
    sha256 = "1arzd1hsgq14rbiwa1ih2g250x6ljna2s2kiqfrw155c612s9cxk";
  };

  buildInputs = [ pkgconfig ];

  propagatedBuildInputs = [ glib gtk3 cairo clutter_gtk sqlite libsoup ];

  meta = with stdenv.lib; {
    inherit version;
    homepage = http://projects.gnome.org/libchamplain/;
    license = licenses.lgpl2Plus;

    description = "C library providing a ClutterActor to display maps";

    longDescription =
      '' libchamplain is a C library providing a ClutterActor to display
         maps.  It also provides a Gtk+ widget to display maps in Gtk+
         applications.  Python and Perl bindings are also available.  It
         supports numerous free map sources such as OpenStreetMap,
         OpenCycleMap, OpenAerialMap, and Maps for free.
      '';

     maintainers = [ ];
     platforms = platforms.gnu;  # arbitrary choice
  };
}
