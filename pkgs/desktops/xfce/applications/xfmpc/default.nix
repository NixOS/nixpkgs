{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook3,
  libxfce4util,
  libxfce4ui,
  gtk3,
  glib,
  libmpd,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfmpc";
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfmpc";
    tag = "xfmpc-${finalAttrs.version}";
    hash = "sha256-fYK8JbWFnkzFpgfmSHa6usnlke4G7pxmdSm7kEQsL5M=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
    # Needed both here and in buildInputs for cross compilation to work
    # as they failed to find native vapigen and thus not building the
    # *.vapi files (this should be fixed when these libraries are built
    # with meson).
    libxfce4ui
    libxfce4util
  ];

  buildInputs = [
    gtk3
    glib
    libxfce4ui
    libxfce4util
    libmpd
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfmpc-"; };

  meta = {
    description = "MPD client written in GTK";
    homepage = "https://docs.xfce.org/apps/xfmpc/start";
    changelog = "https://gitlab.xfce.org/apps/xfmpc/-/blob/xfmpc-${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    teams = [ lib.teams.xfce ];
    mainProgram = "xfmpc";
  };
})
