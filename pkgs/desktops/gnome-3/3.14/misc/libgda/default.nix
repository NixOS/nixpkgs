{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, gtk3 }:

let
  major = "5.2";
  minor = "2";

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "libgda-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libgda/${major}/${name}.tar.xz";
    sha256 = "c9b8b1c32f1011e47b73c5dcf36649aaef2f1edaa5f5d75be20d9caadc2bc3e4";
  };

  configureFlags = [
    "--enable-gi-system-install=no"
  ];

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig intltool itstool libxml2 gtk3 ];

  meta = with stdenv.lib; {
    description = "Database access library";
    homepage = http://www.gnome-db.org/;
    license = [ licenses.lgpl2 licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
