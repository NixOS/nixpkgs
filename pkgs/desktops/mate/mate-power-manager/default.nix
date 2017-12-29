{ stdenv, fetchurl, pkgconfig, intltool, glib, itstool, libxml2, mate, libnotify, libcanberra_gtk3, dbus_glib, upower, gnome3, libtool, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-power-manager-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1gmka9ybxvkrdjaga1md6pbw6q1cx5yxb58ai5315a0f5p45y36x";
  };

  buildInputs = [
     glib
     itstool
     libxml2
     libcanberra_gtk3
     gnome3.gtk
     gnome3.libgnome_keyring
     libnotify
     dbus_glib
     upower

     mate.mate-panel
  ];

  nativeBuildInputs = [
    pkgconfig
    intltool
    libtool
    wrapGAppsHook
  ];

  configureFlags = [ "--enable-applets" ];

  meta = with stdenv.lib; {
    description = "The MATE Power Manager";
    homepage = http://mate-desktop.org;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo maintainers.chpatrick ];
  };
}
