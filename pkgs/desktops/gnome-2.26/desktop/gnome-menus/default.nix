{stdenv, fetchurl, pkgconfig, python, glib, intltool}:

stdenv.mkDerivation {
  name = "gnome-menus-2.26.1";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/gnome-menus-2.26.1.tar.bz2;
    sha256 = "1r44zrmkb2s29f32q8pn06khr50s3b2kcbmkgfl5gvrsczv9cmia";
  };
  buildInputs = [ pkgconfig python glib intltool ];
}
