{stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk, pango, 
  libxml2Python, perl, intltool, gettext}:

stdenv.mkDerivation {
  name = "gtksourceview-2.9.9";
  src = fetchurl {
    url = mirror://gnome/sources/gtksourceview/2.9/gtksourceview-2.9.9.tar.bz2;
    sha256 = "0d0i586nj8jsqqfcjcvaj0yzc3sid3s1a4y62xr0qbddkbn1wllj";
  };
  buildInputs = [pkgconfig atk cairo glib gtk pango libxml2Python perl intltool
    gettext];
}
