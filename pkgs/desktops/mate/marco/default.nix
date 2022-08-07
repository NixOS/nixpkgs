{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, libxml2
, libcanberra-gtk3
, libgtop
, libXdamage
, libXpresent
, libstartup_notification
, gnome
, glib
, gtk3
, mate-settings-daemon
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "marco";
  version = "1.26.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "01avxrg2fc6grfrp6hl8b0im4scy9xf6011swfrhli87ig6hhg7n";
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
    gnome.zenity
    mate-settings-daemon
  ];

  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname version; };

  meta = with lib; {
    description = "MATE default window manager";
    homepage = "https://github.com/mate-desktop/marco";
    license = [ licenses.gpl2Plus ];
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
