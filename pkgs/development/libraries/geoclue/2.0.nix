{ fetchurl, stdenv, intltool, pkgconfig, glib, json_glib, libsoup, geoip
, dbus, dbus_glib, modemmanager, avahi
}:

stdenv.mkDerivation rec {
  name = "geoclue-2.4.2";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/geoclue/releases/2.4/${name}.tar.xz";
    sha256 = "0g4krigdaf5ipkp4mi16rca62crr8pdk3wkhm0fxbcqnil75fyy4";
  };

  buildInputs =
   [ intltool pkgconfig glib json_glib libsoup geoip
     dbus dbus_glib modemmanager avahi
   ];

  preConfigure = ''
     substituteInPlace configure --replace "-Werror" ""
  '';

  configureFlags = [ "--with-systemdsystemunitdir=$(out)/etc/systemd/system" ];

  propagatedBuildInputs = [ dbus dbus_glib glib ];

  meta = with stdenv.lib; {
    description = "Geolocation framework and some data providers";
    maintainers = with maintainers; [ raskin garbas ];
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}
