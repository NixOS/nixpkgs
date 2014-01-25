{ stdenv, fetchurl, pkgconfig, glib, itstool, libxml2, intltool, accountservice, libX11
, gtk, libcanberra_gtk3, pam, libtool, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "gdm-3.10.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gdm/3.10/${name}.tar.xz";
    sha256 = "1rva3djas48m8w1gyv3nds3jxfkirdfl0bk30x79mizrk80456jl";
  };

  buildInputs = [ pkgconfig glib itstool libxml2 intltool accountservice
                  gobjectIntrospection libX11 gtk libcanberra_gtk3 pam libtool ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
