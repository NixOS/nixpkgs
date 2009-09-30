{stdenv, fetchurl, pkgconfig, atk, cairo, glib, gtk, pango, 
  libxml2, perl, intltool}:

stdenv.mkDerivation {
  name = "gtksourceview-2.8.1";
  src = fetchurl {
    url = mirror://gnome/sources/gtksourceview/2.8/gtksourceview-2.8.1.tar.bz2;
    sha256 = "02irdw8sz374d3k51sx21hm7vmpkcwrhmnpp3v6afa2jcwi84zp6";
  };
  buildInputs = [pkgconfig atk cairo glib gtk pango libxml2 perl intltool];
}
