{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  itstool,
  libxml2,
  accountsservice,
  caja,
  dbus-glib,
  libxklavier,
  libcanberra-gtk3,
  libgtop,
  libmatekbd,
  librsvg,
  libayatana-appindicator,
  glib,
  desktop-file-utils,
  dconf,
  gtk3,
  polkit,
  marco,
  mate-desktop,
  mate-menus,
  mate-panel,
  mate-settings-daemon,
  udisks2,
  systemd,
  hicolor-icon-theme,
  wrapGAppsHook3,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-control-center";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "6/LHBP1SSNwvmDb/KQKIae8p1QVJB8xhVzS2ODp5FLw=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    itstool
    desktop-file-utils
    wrapGAppsHook3
  ];

  buildInputs = [
    accountsservice
    libxml2
    dbus-glib
    libxklavier
    libcanberra-gtk3
    libgtop
    libmatekbd
    librsvg
    libayatana-appindicator
    gtk3
    dconf
    polkit
    hicolor-icon-theme
    marco
    mate-desktop
    mate-menus
    mate-panel # for org.mate.panel schema, see m-c-c#678
    mate-settings-daemon
    udisks2
    systemd
  ];

  postPatch = ''
    substituteInPlace capplets/system-info/mate-system-info.c \
      --replace-fail "/usr/bin/mate-about" "${mate-desktop}/bin/mate-about"
  '';

  configureFlags = [ "--disable-update-mimedb" ];

  preFixup = ''
    gappsWrapperArgs+=(
      # WM keyboard shortcuts
      --prefix XDG_DATA_DIRS : "${marco}/share"
      # Desktop font, works only when passed after gtk3 schemas in the wrapper for some reason
      --prefix XDG_DATA_DIRS : "${glib.getSchemaDataDirPath caja}"
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
