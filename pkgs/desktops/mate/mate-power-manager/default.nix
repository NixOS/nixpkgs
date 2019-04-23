{ stdenv, fetchurl, pkgconfig, intltool, glib, itstool, libxml2, mate, libnotify, libcanberra-gtk3, dbus-glib, upower, gnome3, gtk3, libtool, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "mate-power-manager-${version}";
  version = "1.20.3";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "17x47j5dkxxsq63bv2jwf3xgnddyy2dya4y14ryivq8q3jh5yhr5";
  };

  buildInputs = [
     glib
     itstool
     libxml2
     libcanberra-gtk3
     gtk3
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
    homepage = https://mate-desktop.org;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo maintainers.chpatrick ];
  };
}
