{ stdenv, fetchurl, pkgconfig, glib, python }:

stdenv.mkDerivation rec {
  name = "libqmi-1.0";

  src = fetchurl {
    url = "http://ftp.acc.umu.se/pub/GNOME/core/3.10/3.10.2/sources/${name}.tar.xz";
    sha256 = "0w4cd7nihp73frh3sfi13fx0rkwmd581xpil54bsjc7pw7z01bd1";
  };

  buildInputs = [ pkgconfig glib python ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
