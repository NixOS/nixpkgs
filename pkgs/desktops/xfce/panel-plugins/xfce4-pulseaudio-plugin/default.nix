{
  stdenv,
  lib,
  fetchFromGitLab,
  exo,
  gtk3,
  libcanberra,
  libpulseaudio,
  libnotify,
  libxfce4ui,
  libxfce4util,
  libxfce4windowing,
  meson,
  ninja,
  pkg-config,
  xfce4-panel,
  xfconf,
  keybinder3,
  glib,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-pulseaudio-plugin";
  version = "0.5.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "panel-plugins";
    repo = "xfce4-pulseaudio-plugin";
    tag = "xfce4-pulseaudio-plugin-${finalAttrs.version}";
    hash = "sha256-FIEV99AV5UiGLTXi9rU4DKK//SolkrOQfpENXQcy64E=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    exo
    glib
    gtk3
    keybinder3
    libcanberra
    libnotify
    libpulseaudio
    libxfce4ui
    libxfce4util
    libxfce4windowing
    xfce4-panel
    xfconf
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-pulseaudio-plugin-"; };

  meta = {
    description = "Adjust the audio volume of the PulseAudio sound system";
    homepage = "https://gitlab.xfce.org/panel-plugins/xfce4-pulseaudio-plugin";
    license = lib.licenses.gpl2Plus;
    maintainers = lib.teams.xfce.members;
    platforms = lib.platforms.linux;
  };
})
