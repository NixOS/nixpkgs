{ stdenv, fetchurl, pkgconfig, glib, gdk_pixbuf, gobjectIntrospection, gnome3 }:

let
  majorVersion = "1.9";
in
stdenv.mkDerivation rec {
  name = "libmediaart-${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libmediaart/${majorVersion}/${name}.tar.xz";
    sha256 = "0vshvm3sfwqs365glamvkmgnzjnmxd15j47xn0ak3p6l57dqlrll";
  };

  buildInputs = [ pkgconfig glib gdk_pixbuf gobjectIntrospection ];

  meta = with stdenv.lib; {
    description = "Library tasked with managing, extracting and handling media art caches";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
