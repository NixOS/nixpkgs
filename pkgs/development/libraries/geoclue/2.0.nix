{ fetchurl, stdenv, intltool, pkgconfig, glib, json_glib, libsoup, geoip
, dbus, dbus_glib, modemmanager, avahi
}:

stdenv.mkDerivation rec {
  name = "geoclue-2.4.1";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/geoclue/releases/2.4/${name}.tar.xz";
    sha256 = "1m1l1npdv804m98xhfpd1wl1whrrp2pjivliwwlnyk86yq0gs6cs";
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

  meta = {
    description = "Geolocation framework and some data providers";
    maintainers = with stdenv.lib.maintainers; [ raskin garbas ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl2;
  };
}
