{ stdenv, intltool, fetchurl, libgtop, pkgconfig, gtk3, glib
, bash, makeWrapper, itstool, gnome3, file }:

stdenv.mkDerivation rec {
  name = "gnome-shell-extensions-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell-extensions/${gnome3.version}/${name}.tar.xz";
    sha256 = "0hd7jskwhrki0s9lmx6vc6rw9y689zp2h7zhlxk90hghy4nkvkc8";
  };

  doCheck = true;

  buildInputs = [ pkgconfig gtk3 glib libgtop intltool itstool
                  makeWrapper file ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GnomeShell/Extensions;
    description = "Modify and extend GNOME Shell functionality and behavior";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
