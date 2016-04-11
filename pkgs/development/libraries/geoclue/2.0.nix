{ fetchurl, stdenv, intltool, pkgconfig, glib, json_glib, libsoup, geoip
, dbus, dbus_glib, modemmanager, avahi
}:

stdenv.mkDerivation rec {
  name = "geoclue-2.4.3";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/geoclue/releases/2.4/${name}.tar.xz";
    sha256 = "0pk07k65dlw37nz8z5spksivsv5nh96xmbi336rf2yfxf2ldpadd";
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
