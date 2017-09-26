{ stdenv, fetchurl, pkgconfig, file, intltool, gmime, libxml2, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  name = "totem-pl-parser-3.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/totem-pl-parser/3.10/${name}.tar.xz";
    sha256 = "38be09bddc46ddecd2b5ed7c82144ef52aafe879a5ec3d8b192b4b64ba995469";
  };

  buildInputs = [ pkgconfig file intltool gmime libxml2 libsoup ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Simple GObject-based library to parse and save a host of playlist formats";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
