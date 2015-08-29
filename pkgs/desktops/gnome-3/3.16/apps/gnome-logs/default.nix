{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, intltool, itstool, libxml2, systemd }:

stdenv.mkDerivation rec {
  name = "gnome-logs-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-logs/${gnome3.version}/${name}.tar.xz";
    sha256 = "0732jbvih5d678idvhlgqik9j9y594agwdx6gwap80459k1a6fg1";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool itstool libxml2
    systemd gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Logs;
    description = "A log viewer for the systemd journal";
    maintainers = gnome3.maintainers;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
