{ stdenv, intltool, fetchurl, libgtop
, pkgconfig, gtk3, glib, hicolor_icon_theme
, bash, makeWrapper, itstool
, gnome3, file }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extensions-3.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/3.10/${name}.tar.xz";
    sha256 = "9baa9ddaf4e14cab6d4d7944d8dc009378b25f995acfd0fd72843f599cb5ae43";
  };

  doCheck = true;

  buildInputs = [ pkgconfig gtk3 glib libgtop intltool itstool
                  makeWrapper file ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeShell/Extensions;
    description = "Modify and extend GNOME Shell functionality and behavior";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
