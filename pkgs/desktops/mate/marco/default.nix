{ lib, stdenv, fetchurl, pkg-config, gettext, itstool, libxml2, libcanberra-gtk3, libgtop
, libXdamage, libXpresent, libstartup_notification, gnome3, gtk3, mate-settings-daemon, wrapGAppsHook, mateUpdateScript }:

stdenv.mkDerivation rec {
  pname = "marco";
  version = "1.24.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "19s2y2s9immp86ni3395mgxl605m2wn10m8399y9qkgw2b5m10s9";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    libcanberra-gtk3
    libgtop
    libXdamage
    libXpresent
    libstartup_notification
    gtk3
    gnome3.zenity
    mate-settings-daemon
  ];

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "MATE default window manager";
    homepage = "https://github.com/mate-desktop/marco";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
