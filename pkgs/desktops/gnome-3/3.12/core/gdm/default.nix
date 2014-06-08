{ stdenv, fetchurl, pkgconfig, glib, itstool, libxml2, intltool, accountservice, libX11
, gtk, libcanberra_gtk3, pam, libtool, gobjectIntrospection, dconf }:

stdenv.mkDerivation rec {
  name = "gdm-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/3.12/${name}.tar.xz";
    sha256 = "cc91fff5afd2a7c3e712c960a0b60744774167dcfc16f486372e1eb3c0aa1cc4";
  };

  buildInputs = [ pkgconfig glib itstool libxml2 intltool accountservice dconf
                  gobjectIntrospection libX11 gtk libcanberra_gtk3 pam libtool ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
