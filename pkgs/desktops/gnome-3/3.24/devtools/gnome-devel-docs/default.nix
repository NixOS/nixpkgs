{ stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ intltool itstool libxml2 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/GNOME/gnome-devel-docs;
    description = "Developer documentation for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.fdl12;
    platforms = platforms.linux;
  };
}
