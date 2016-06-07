{ stdenv, fetchurl, gnome3, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs = [ intltool itstool libxml2 ];

  meta = with stdenv.lib; {
    homepage = https://live.gnome.org/DocumentationProject;
    description = "Help a new user get started in GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.cc-by-sa-30;
    platforms = platforms.linux;
  };
}
