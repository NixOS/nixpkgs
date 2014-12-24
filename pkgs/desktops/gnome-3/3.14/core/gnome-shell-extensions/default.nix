{ stdenv, intltool, fetchurl, libgtop
, pkgconfig, gtk3, glib, hicolor_icon_theme
, bash, makeWrapper, itstool
, gnome3, file }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extensions-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${gnome3.version}/${name}.tar.xz";
    sha256 = "bf0bf033d9ddd62ff005f55c2917b49df0719132df9c081e8d7e27c571819135";
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
