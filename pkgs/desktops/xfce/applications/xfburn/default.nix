{
  stdenv,
  lib,
  fetchFromGitLab,
  docbook_xsl,
  glib,
  libxslt,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  exo,
  gst_all_1,
  gtk3,
  libburn,
  libgudev,
  libisofs,
  libxfce4ui,
  libxfce4util,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfburn";
  version = "0.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfburn";
    tag = "xfburn-${finalAttrs.version}";
    hash = "sha256-10MjUxy1Ul6CVLdEWFnjppgsI4fAUWqkT2azJBzp0/Q=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    docbook_xsl
    glib # glib-genmarshal
    libxslt # xsltproc
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    exo
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk3
    libburn
    libgudev
    libisofs
    libxfce4ui
    libxfce4util
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "xfburn-"; };

  meta = {
    description = "Disc burner and project creator for Xfce";
    homepage = "https://gitlab.xfce.org/apps/xfburn";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfburn";
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
