{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  glib,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gigolo";
  version = "0.6.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "gigolo";
    tag = "gigolo-${finalAttrs.version}";
    hash = "sha256-tyFjVvtDE25y6rnmlESdl8s/GdyHGqbn2Dn/ymIIgWs=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "gigolo-"; };

  meta = {
    description = "Frontend to easily manage connections to remote filesystems";
    homepage = "https://gitlab.xfce.org/apps/gigolo";
    license = lib.licenses.gpl2Plus;
    mainProgram = "gigolo";
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
