{stdenv, fetchurl, pkgconfig, python, glib, intltool}:

stdenv.mkDerivation {
  name = "gnome-menus-2.30.5";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-menus/2.30/gnome-menus-2.30.5.tar.bz2;
    sha256 = "1ajckii51spmkgfc0168c56x0syz5vwb2fp8b81c5s6n0r85dk3d";
  };

  buildInputs = [ pkgconfig python glib intltool ];
}
