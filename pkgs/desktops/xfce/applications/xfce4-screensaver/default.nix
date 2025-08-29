{
  stdenv,
  lib,
  fetchFromGitLab,
  docbook_xml_dtd_412,
  docbook-xsl-ns,
  gettext,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  xmlto,
  dbus-glib,
  garcon,
  glib,
  gtk3,
  libX11,
  libXScrnSaver,
  libXrandr,
  libwnck,
  libxfce4ui,
  libxfce4util,
  libxklavier,
  pam,
  python3,
  systemd,
  xfconf,
  xfdesktop,
  gitUpdater,
}:

let
  # For xfce4-screensaver-configure
  pythonEnv = python3.withPackages (pp: [ pp.pygobject3 ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-screensaver";
  version = "4.20.1";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfce4-screensaver";
    tag = "xfce4-screensaver-${finalAttrs.version}";
    hash = "sha256-FdO6fZTKBPjncjBBe2rK5DSfVLHTRFpo9NtgZ5nFgRU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    docbook_xml_dtd_412
    docbook-xsl-ns
    gettext
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    wrapGAppsHook3
    xmlto
  ];

  buildInputs = [
    dbus-glib
    garcon
    glib
    gtk3
    libX11
    libXScrnSaver
    libXrandr
    libwnck
    libxfce4ui
    libxfce4util
    libxklavier
    pam
    pythonEnv
    systemd
    xfconf
  ];

  preFixup = ''
    # For default wallpaper.
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xfdesktop}/share")
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-screensaver-"; };

  meta = {
    homepage = "https://gitlab.xfce.org/apps/xfce4-screensaver";
    description = "Screensaver for Xfce";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-screensaver";
    maintainers = with lib.maintainers; [ symphorien ];
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
