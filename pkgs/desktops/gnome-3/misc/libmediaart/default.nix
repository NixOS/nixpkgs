{ stdenv, fetchurl, pkgconfig, glib, gdk_pixbuf, gobjectIntrospection, gnome3 }:

let
  majorVersion = "1.9";
in
stdenv.mkDerivation rec {
  name = "libmediaart-${majorVersion}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/libmediaart/${majorVersion}/${name}.tar.xz";
    sha256 = "0jg9gwxmhdxcbwb5svgkxkd3yl1d14wqzckcgg2swkn81i7al52v";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib gdk_pixbuf gobjectIntrospection ];

  meta = with stdenv.lib; {
    description = "Library tasked with managing, extracting and handling media art caches";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
