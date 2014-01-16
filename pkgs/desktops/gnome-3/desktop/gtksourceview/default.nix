{ stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk3, pango
, libxml2Python, perl, intltool, gettext }:

stdenv.mkDerivation rec {
  name = "gtksourceview-${version}";
  version = "3.10.1";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gtksourceview/3.10/gtksourceview-${version}.tar.xz";
    sha256 = "008bzfr1s6ywpj8c8qx7495lz9g0ziccwbxg88s0l4dl6bw49piq";
  };

  buildInputs = [ pkgconfig atk cairo glib gtk3 pango
                  libxml2Python perl intltool gettext ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
