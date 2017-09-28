{ stdenv, intltool, fetchurl, libgtop, pkgconfig, gtk3, glib
, bash, makeWrapper, itstool, gnome3, file }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 glib libgtop intltool itstool
                  makeWrapper file ];

  configureFlags = [ "--enable-extensions=all" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeShell/Extensions;
    description = "Modify and extend GNOME Shell functionality and behavior";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
