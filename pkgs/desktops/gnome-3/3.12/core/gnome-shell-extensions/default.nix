{ stdenv, intltool, fetchurl, libgtop
, pkgconfig, gtk3, glib, hicolor_icon_theme
, bash, makeWrapper, itstool
, gnome3, file }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extensions-3.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/3.12/${name}.tar.xz";
    sha256 = "30ba6e4792062e5a5cdd18e4a12230e68bfed1ded7de433ad241dd75e7ae2fc6";
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
