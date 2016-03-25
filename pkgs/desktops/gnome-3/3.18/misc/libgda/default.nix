{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, gtk3, openssl }:

let
  major = "5.2";
  minor = "4";

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "libgda-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libgda/${major}/${name}.tar.xz";
    sha256 = "0pkn9dlb53j73ajkhj8lkf5pa26ci1gwl0bcvxdsmjrwb3fkivic";
  };

  configureFlags = [
    "--enable-gi-system-install=no"
  ];

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig intltool itstool libxml2 gtk3 openssl ];

  meta = with stdenv.lib; {
    description = "Database access library";
    homepage = http://www.gnome-db.org/;
    license = [ licenses.lgpl2 licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
