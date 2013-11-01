{ fetchurl, stdenv, intltool, pkgconfig, glib, json_glib, libsoup, geoip
, dbus, dbus_glib
}:

stdenv.mkDerivation rec {
  name = "geoclue-2.0.0";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/geoclue/releases/2.0/${name}.tar.xz";
    sha256 = "18b7ikdcw2rm04gzw82216shp5m9pghvnsddw233s5jswn2g30ja";
  };

  buildInputs =
   [ intltool pkgconfig glib json_glib libsoup geoip
     dbus dbus_glib
   ];

  preConfigure = ''
     substituteInPlace configure --replace "-Werror" ""
  '';

  propagatedBuildInputs = [ dbus dbus_glib glib ];

  meta = {
    description = "Geolocation framework and some data providers";
    maintainers = with stdenv.lib.maintainers; [ raskin garbas ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl2;
  };
}
