{ stdenv, fetchurl, pkgconfig, gettext, glib, itstool, libxml2, mate-panel, libnotify, libcanberra-gtk3, dbus-glib, upower, gnome3, gtk3, libtool, polkit, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "mate-power-manager";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "13ar40x5hs4d4h81q8qsy0agbx5wnarry3mbhws54zydcxd7j20a";
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
     mate-panel
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
