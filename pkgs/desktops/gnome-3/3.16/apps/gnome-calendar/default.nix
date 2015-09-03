{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, intltool, evolution_data_server, sqlite, libxml2, libsoup
, glib }:

stdenv.mkDerivation rec {
  name = "gnome-calendar-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calendar/${gnome3.version}/${name}.tar.xz";
    sha256 = "0vqwps86whf8jgq7q4hdrbnmlaxppgrfa3j7n6ddpqzkb3gf2c5m";
  };

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool evolution_data_server
    sqlite libxml2 libsoup glib gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Calendar;
    description = "Simple and beautiful calendar application for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
