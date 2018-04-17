{ fetchurl, stdenv, intltool, pkgconfig, glib, json-glib, libsoup, geoip
, dbus, dbus-glib, modemmanager, avahi, glib-networking, wrapGAppsHook, gobjectIntrospection
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "geoclue-2.4.7";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/geoclue/releases/2.4/${name}.tar.xz";
    sha256 = "19hfmr8fa1js8ynazdyjxlyrqpjn6m1719ay70ilga4rayxrcyyi";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig intltool wrapGAppsHook gobjectIntrospection
  ];

  buildInputs = [ glib json-glib libsoup geoip
     dbus dbus-glib avahi
   ] ++ optionals (!stdenv.isDarwin) [ modemmanager ];

  propagatedBuildInputs = [ dbus dbus-glib glib glib-networking ];

  preConfigure = ''
     substituteInPlace configure --replace "-Werror" ""
  '';

  configureFlags = [ "--with-systemdsystemunitdir=$(out)/etc/systemd/system" "--enable-introspection" ] ++
                   optionals stdenv.isDarwin [
                       "--disable-silent-rules"
                       "--disable-3g-source"
                       "--disable-cdma-source"
                       "--disable-modem-gps-source"
                       "--disable-nmea-source" ];

  postInstall = ''
    sed -i $dev/lib/pkgconfig/libgeoclue-2.0.pc -e "s|includedir=.*|includedir=$dev/include|"
  '';

  meta = with stdenv.lib; {
    description = "Geolocation framework and some data providers";
    homepage = https://freedesktop.org/wiki/Software/GeoClue/;
    maintainers = with maintainers; [ raskin garbas ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl2;
  };
}
