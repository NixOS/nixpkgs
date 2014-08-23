{ stdenv, fetchurl, pkgconfig, glib, intltool, json_glib, rest, libsoup, gtk, gnome_online_accounts }:

stdenv.mkDerivation rec {
  name = "libzapojit-0.0.3";

  src = fetchurl {
    url = "http://ftp.acc.umu.se/pub/GNOME/core/3.10/3.10.2/sources/${name}.tar.xz";
    sha256 = "0zn3s7ryjc3k1abj4k55dr2na844l451nrg9s6cvnnhh569zj99x";
  };

  buildInputs = [ pkgconfig glib intltool json_glib rest libsoup gtk gnome_online_accounts ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
