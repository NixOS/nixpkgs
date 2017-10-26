{ fetchurl, stdenv, intltool, libintlOrEmpty, pkgconfig, glib, json_glib, libsoup, geoip
, dbus, dbus_glib, modemmanager, avahi, glib_networking, wrapGAppsHook
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "geoclue-2.4.7";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/geoclue/releases/2.4/${name}.tar.xz";
    sha256 = "19hfmr8fa1js8ynazdyjxlyrqpjn6m1719ay70ilga4rayxrcyyi";
  };

  nativeBuildInputs = [
    pkgconfig intltool wrapGAppsHook
  ];

  buildInputs = libintlOrEmpty ++
   [ glib json_glib libsoup geoip
     dbus dbus_glib avahi
   ] ++ optionals (!stdenv.isDarwin) [ modemmanager ];

  preConfigure = ''
     substituteInPlace configure --replace "-Werror" ""
  '';

  configureFlags = [ "--with-systemdsystemunitdir=$(out)/etc/systemd/system" ] ++
                   optionals stdenv.isDarwin [
                       "--disable-silent-rules"
                       "--disable-3g-source"
                       "--disable-cdma-source"
                       "--disable-modem-gps-source"
                       "--disable-nmea-source" ];

  NIX_CFLAGS_COMPILE = optionalString stdenv.isDarwin " -lintl";

  propagatedBuildInputs = [ dbus dbus_glib glib glib_networking ];

  meta = with stdenv.lib; {
    description = "Geolocation framework and some data providers";
    maintainers = with maintainers; [ raskin garbas ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl2;
  };
}
