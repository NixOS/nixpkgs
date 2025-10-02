{
  stdenv,
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  dbus,
  dbus-glib,
  gst_all_1,
  glib,
  gtk3,
  libnotify,
  libX11,
  libxfce4ui,
  libxfce4util,
  taglib,
  xfconf,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parole";
  version = "4.20.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "parole";
    tag = "parole-${finalAttrs.version}";
    hash = "sha256-I1wZsuZ/NM5bH6QTJpwd5WL9cIGNtkAxA2j5vhhdaTE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    dbus-glib # dbus-binding-tool
    glib # glib-genmarshal
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus
    dbus-glib
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    glib
    gtk3
    libnotify
    libX11
    libxfce4ui
    libxfce4util
    taglib
    xfconf
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "parole-"; };

  meta = {
    description = "Modern simple media player";
    homepage = "https://gitlab.xfce.org/apps/parole";
    license = lib.licenses.gpl2Plus;
    mainProgram = "parole";
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
