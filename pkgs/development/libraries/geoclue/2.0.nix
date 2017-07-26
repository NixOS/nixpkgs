{ fetchurl, stdenv, intltool, libintlOrEmpty, pkgconfig, glib, json_glib, libsoup, geoip
, dbus, dbus_glib, modemmanager, avahi
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "geoclue-2.4.3";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/geoclue/releases/2.4/${name}.tar.xz";
    sha256 = "0pk07k65dlw37nz8z5spksivsv5nh96xmbi336rf2yfxf2ldpadd";
  };

  buildInputs = libintlOrEmpty ++
   [ intltool pkgconfig glib json_glib libsoup geoip
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

  propagatedBuildInputs = [ dbus dbus_glib glib ];

  meta = with stdenv.lib; {
    description = "Geolocation framework and some data providers";
    maintainers = with maintainers; [ raskin garbas ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl2;
  };
}
