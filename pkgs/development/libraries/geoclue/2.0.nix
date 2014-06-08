{ fetchurl, stdenv, intltool, pkgconfig, glib, json_glib, libsoup, geoip
, dbus, dbus_glib, networkmanager, modemmanager
}:

stdenv.mkDerivation rec {
  name = "geoclue-2.1.8";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/geoclue/releases/2.1/${name}.tar.xz";
    sha256 = "05h102110gsxxvmvllssfz7ldjpwrrb5sqg5rbpibys6iy4w1k6m";
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
