{ stdenv, fetchurl, pkgconfig, glib, libcanberra, gobjectIntrospection, libtool, gnome3 }:

let
  majVer = "1.0";
in stdenv.mkDerivation rec {
  name = "gsound-${majVer}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gsound/${majVer}/${name}.tar.xz";
    sha256 = "ea0dd94429c0645f2f98824274ef04543fe459dd83a5449a68910acc3ba67f29";
  };

  buildInputs = [ pkgconfig glib libcanberra gobjectIntrospection libtool ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GSound;
    description = "Small library for playing system sounds";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
