{stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk, pango, 
  libxml2Python, perl, intltool, gettext}:

stdenv.mkDerivation rec {
  name = "gtksourceview-${version}";
  version = "2.10.5";

  src = fetchurl {
    url = "mirror://gnome/sources/gtksourceview/2.10/${name}.tar.bz2";
    sha256 = "c585773743b1df8a04b1be7f7d90eecdf22681490d6810be54c81a7ae152191e";
  };
  buildInputs = [pkgconfig atk cairo glib gtk pango libxml2Python perl intltool
    gettext];
}
