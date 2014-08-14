{ fetchurl, stdenv, intltool, pkgconfig, glib, json_glib, libsoup, geoip
, dbus, dbus_glib, networkmanager, modemmanager
}:

stdenv.mkDerivation rec {
  name = "geoclue-2.1.9";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/geoclue/releases/2.1/${name}.tar.xz";
    sha256 = "0aq9fqlvvc8jqbshp3mbcc1j5hq4fzjy8hd1yxcl6xrd0jkfw5ml";
  };

  buildInputs =
   [ intltool pkgconfig glib json_glib libsoup geoip
     dbus dbus_glib networkmanager modemmanager
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
