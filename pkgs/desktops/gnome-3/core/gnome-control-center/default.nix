{ fetchurl, stdenv, pkgconfig, gnome3, ibus, intltool, upower, libcanberra
, libxml2, polkit, libxslt, libgtop, libsoup, colord, pulseaudio, fontconfig }:

# http://ftp.gnome.org/pub/GNOME/teams/releng/3.10.2/gnome-suites-core-3.10.2.modules
# TODO: colord_gtk


stdenv.mkDerivation rec {
  name = "gnome-control-center-3.10.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-control-center/3.10/${name}.tar.xz";
    sha256 = "1ac34kqkf174w0qc12p927dfhcm69xnv7fqzmbhjab56rn49wypn";
  };

  buildInputs = with gnome3;
    [ pkgconfig intltool ibus gtk glib upower libcanberra gsettings_desktop_schemas
      libxml2 gnome_desktop gnome_settings_daemon polkit libxslt libgtop gnome-menus
      gnome_online_accounts libsoup colord pulseaudio fontconfig ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
