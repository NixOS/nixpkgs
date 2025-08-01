{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gtk3,
  libxfce4ui,
  libxfce4util,
  python3,
  gitUpdater,
}:

let
  pythonEnv = python3.withPackages (ps: [
    ps.pygobject3
    ps.psutil
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-panel-profiles";
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfce4-panel-profiles";
    rev = "xfce4-panel-profiles-${finalAttrs.version}";
    hash = "sha256-4sUNlabWp6WpBlePVFHejq/+TXiJYSQTnZFp5B258Wc=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    libxfce4util
    pythonEnv
  ];

  mesonFlags = [
    "-Dpython-path=${lib.getExe pythonEnv}"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-panel-profiles-"; };

  meta = with lib; {
    homepage = "https://docs.xfce.org/apps/xfce4-panel-profiles/start";
    description = "Simple application to manage Xfce panel layouts";
    mainProgram = "xfce4-panel-profiles";
    teams = [ teams.xfce ];
    platforms = platforms.linux;
  };
})
