{ fetchurl, stdenv, pkgconfig, glib, gtk3, cairo, clutter, sqlite
, clutter-gtk, libsoup, gobjectIntrospection /*, libmemphis */ }:

stdenv.mkDerivation rec {
  major = "0.12";
  version = "${major}.16";
  name = "libchamplain-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libchamplain/${major}/${name}.tar.xz";
    sha256 = "13chvc2n074i0jw5jlb8i7cysda4yqx58ca6y3mrlrl9g37k2zja";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gobjectIntrospection ];

  propagatedBuildInputs = [ glib gtk3 cairo clutter-gtk sqlite libsoup ];

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
