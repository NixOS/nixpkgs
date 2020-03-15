{ stdenv, fetchurl, pkgconfig, gettext, glib, itstool, libxml2, mate, libnotify, libcanberra-gtk3, dbus-glib, upower, gnome3, gtk3, libtool, polkit, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-power-manager";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1h6wm8vna97iayhwqh7rfsc87715np12nxa72w27p4zl54bdkdlg";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    libtool
    wrapGAppsHook
  ];

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
     polkit
     mate.mate-panel
  ];

  configureFlags = [ "--enable-applets" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The MATE Power Manager";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo chpatrick ];
  };
}
