{ stdenv, intltool, fetchurl, pkgconfig, glib
, gnome3, libsoup, json-glib }:

stdenv.mkDerivation rec {
  name = "gfbgraph-0.2.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gfbgraph/0.2/${name}.tar.xz";
    sha256 = "1dp0v8ia35fxs9yhnqpxj3ir5lh018jlbiwifjfn8ayy7h47j4fs";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gnome3.gnome-online-accounts ];
  propagatedBuildInputs = [ libsoup json-glib gnome3.rest ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GLib/GObject wrapper for the Facebook Graph API";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
