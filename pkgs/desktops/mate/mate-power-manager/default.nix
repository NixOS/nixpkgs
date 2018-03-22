{ stdenv, fetchurl, pkgconfig, intltool, glib, itstool, libxml2, mate, libnotify, libcanberra-gtk3, dbus-glib, upower, gnome3, libtool, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-power-manager-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "038c2q5kqvqmkp1i93p4pp9x8p6a9i7lyn3nv522mq06qsbynbww";
  };

  buildInputs = [
     glib
     itstool
     libxml2
     libcanberra-gtk3
     gnome3.gtk
     gnome3.libgnome-keyring
     libnotify
     dbus-glib
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
