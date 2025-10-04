{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  glib,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wrapGAppsHook3,
  exo,
  gtk3,
  libX11,
  libXext,
  libXfixes,
  libXtst,
  libxfce4ui,
  libxfce4util,
  wayland,
  wlr-protocols,
  xfce4-panel,
  xfconf,
  curl,
  zenity,
  jq,
  xclip,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-screenshooter";
  version = "1.11.2";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfce4-screenshooter";
    tag = "xfce4-screenshooter-${finalAttrs.version}";
    hash = "sha256-LELPY3SU25e3Dk9/OljWMLIbZYrDiQD1h6dMq+jRaH8=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gettext
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    exo
    gtk3
    libX11
    libXext
    libXfixes
    libXtst
    libxfce4ui
    libxfce4util
    wayland
    wlr-protocols
    xfce4-panel
    xfconf
  ];

  preFixup = ''
    # For Imgur upload action
    # https://gitlab.xfce.org/apps/xfce4-screenshooter/-/merge_requests/51
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          zenity
          jq
          xclip
        ]
      }
    )
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-screenshooter-"; };

  meta = {
    description = "Screenshot utility for the Xfce desktop";
    homepage = "https://gitlab.xfce.org/apps/xfce4-screenshooter";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-screenshooter";
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
