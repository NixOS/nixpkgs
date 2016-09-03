{ stdenv, fetchurl, pkgconfig, intltool, itstool, libxml2, gtk3, openssl }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  configureFlags = [
    "--enable-gi-system-install=no"
  ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  buildInputs = [ pkgconfig intltool itstool libxml2 gtk3 openssl ];

  meta = with stdenv.lib; {
    description = "Database access library";
    homepage = http://www.gnome-db.org/;
    license = [ licenses.lgpl2 licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
