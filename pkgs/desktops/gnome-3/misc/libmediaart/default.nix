{ stdenv, fetchurl, pkgconfig, glib, gdk_pixbuf, gobjectIntrospection, gnome3 }:

let
  majorVersion = "1.9";
in
stdenv.mkDerivation rec {
  name = "libmediaart-${majorVersion}.4";

  src = fetchurl {
    url = "mirror://gnome/sources/libmediaart/${majorVersion}/${name}.tar.xz";
    sha256 = "a57be017257e4815389afe4f58fdacb6a50e74fd185452b23a652ee56b04813d";
  };

  nativeBuildInputs = [ pkgconfig gobjectIntrospection ];
  buildInputs = [ glib gdk_pixbuf ];

  meta = with stdenv.lib; {
    description = "Library tasked with managing, extracting and handling media art caches";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
