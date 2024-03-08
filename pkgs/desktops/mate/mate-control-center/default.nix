{ lib
, stdenv
, fetchurl
, pkg-config
, gettext
, itstool
, libxml2
, dbus-glib
, libxklavier
, libcanberra-gtk3
, librsvg
, libappindicator-gtk3
, glib
, desktop-file-utils
, dconf
, gtk3
, polkit
, mate
, hicolor-icon-theme
, wrapGAppsHook
, mateUpdateScript
}:

stdenv.mkDerivation rec {
  pname = "mate-control-center";
  version = "1.26.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "4F9JKjtleqVvxY989xvIyA344lNR/eTbT1I6uNtbVgg=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    libxml2
    dbus-glib
    libxklavier
    libcanberra-gtk3
    librsvg
    libappindicator-gtk3
    gtk3
    dconf
    polkit
    hicolor-icon-theme
    mate.mate-desktop
    mate.libmatekbd
    mate.mate-menus
    mate.mate-panel # for org.mate.panel schema, see m-c-c#678
    mate.marco
    mate.mate-settings-daemon
  ];

  configureFlags = [ "--disable-update-mimedb" ];

  preFixup = ''
    gappsWrapperArgs+=(
      # WM keyboard shortcuts
      --prefix XDG_DATA_DIRS : "${mate.marco}/share"
      # Desktop font, works only when passed after gtk3 schemas in the wrapper for some reason
      --prefix XDG_DATA_DIRS : "${glib.getSchemaDataDirPath mate.caja}"
    )
  '';

  enableParallelBuilding = true;

  passthru.updateScript = mateUpdateScript { inherit pname; };

  meta = with lib; {
    description = "Utilities to configure the MATE desktop";
    homepage = "https://github.com/mate-desktop/mate-control-center";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = teams.mate.members;
  };
}
