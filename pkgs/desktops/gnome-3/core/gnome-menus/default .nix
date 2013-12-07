{ stdenv, fetchurl, intltool, pkgconfig, glib}: 
let
  version = "3.10.1";
in
stdenv.mkDerivation {
  name = "gnome-menus-${version}";
  
    src = fetchurl {
    url = "http://ftp.gnome.org/pub/gnome/sources/gnome-menus/3.10/gnome-menus-3.10.1.tar.xz";
    sha256 = "0wcacs1vk3pld8wvrwq7fdrm11i56nrajkrp6j1da6jc4yx0m5a6";
  };
  
  
  preBuild = "patchShebangs ./scripts";

  buildInputs=[ intltool pkgconfig glib ];

  meta = {
    homepage = "http://www.gnome.org";
    description = "Gnome menu specification " ;

    platforms = stdenv.lib.platforms.linux;
  };
}
