{ stdenv, fetchurl, pkgconfig, intltool, iconnamingutils }:

stdenv.mkDerivation rec {
  name = "gnome-icon-theme-2.30.3";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-icon-theme/2.30/gnome-icon-theme-2.30.3.tar.bz2;
    sha256 = "1iysjfw3rajv9skdhshwcbjsm4jrsl6sfvqzrfynsfl4fyfjyzj1";
  };
  
  buildNativeInputs = [ pkgconfig intltool iconnamingutils ];
}
