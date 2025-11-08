{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
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
  mate-common,
  mate-desktop,
  mate-menus,
  mate-panel,
  mate-settings-daemon,
  udisks,
  systemd,
  hicolor-icon-theme,
  wrapGAppsHook3,
  yelp-tools,
  mateUpdateScript,
}:

stdenv.mkDerivation rec {
  pname = "mate-control-center";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-control-center";
    tag = "v${version}";
    hash = "sha256-rsEu3Ig6GxqPOvAFOXhkEoXM+etyjWpQWHGOsA+myJs=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    gettext
    itstool
    desktop-file-utils
    mate-common # mate-common.m4 macros
    wrapGAppsHook3
    yelp-tools
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
    udisks
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
    teams = [ teams.mate ];
  };
}
