{stdenv, fetchurl, pkgconfig, python, glib, intltool}:

stdenv.mkDerivation {
  name = "gnome-menus-2.28.0";
  src = fetchurl {
    url = nirror://gnome/sources/gnome-menus/2.28/gnome-menus-2.28.0.tar.bz2;
    sha256 = "1lgkqa5gn0g61mfmr2xj2yfg4qjpdavj8rgbdg4bldznphmhp11s";
  };
  buildInputs = [ pkgconfig python glib intltool ];
}
