{ stdenv, intltool, fetchurl, libgtop
, pkgconfig, gtk3, glib, hicolor_icon_theme
, bash, makeWrapper, itstool
, gnome3, file }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extensions-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${gnome3.version}/${name}.tar.xz";
    sha256 = "1yrm3f6ml6h6g1cihq91zc8mcfs8clzijaby21fzc55wvrwwwwg0";
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
