{ lib, stdenv, fetchurl, pkg-config, gettext, glib, itstool, libxml2, mate-panel, libnotify, libcanberra-gtk3, dbus-glib, upower, gnome3, gtk3, libtool, polkit, wrapGAppsHook, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "mate-power-manager";
  version = "1.24.3";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1rmcrpii3hl35qjznk6h5cq72n60cs12n294hjyakxr9kvgns7l6";
  };

  nativeBuildInputs = [
    pkg-config
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

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "The MATE Power Manager";
    homepage = "https://mate-desktop.org";
    license = with licenses; [ gpl2Plus fdl11Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo chpatrick ];
  };
}
