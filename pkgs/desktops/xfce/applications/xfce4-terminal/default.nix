{
  stdenv,
  lib,
  fetchFromGitLab,
  docbook_xml_dtd_45,
  docbook_xsl,
  glib,
  libxslt, # xsltproc
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  gtk-layer-shell,
  libutempter,
  libX11,
  libxfce4ui,
  pcre2,
  vte,
  vte-sixel,
  xfconf,
  nixosTests,
  gitUpdater,
  withSixel ? false,
}:

let
  vte' = if withSixel then vte-sixel else vte;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xfce4-terminal";
  version = "1.1.5";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfce4-terminal";
    tag = "xfce4-terminal-${finalAttrs.version}";
    hash = "sha256-qNXrxUjmuY6+k95/zcOu1/CUfhb1u0Ca91aFD3c4uoc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
    glib # glib-mkenums
    libxslt # xsltproc
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    gtk-layer-shell
    libutempter
    libX11
    libxfce4ui
    pcre2
    vte'
    xfconf
  ];

  passthru = {
    tests.test = nixosTests.terminal-emulators.xfce4-terminal;
    updateScript = gitUpdater { rev-prefix = "xfce4-terminal-"; };
  };

  meta = {
    description = "Modern terminal emulator";
    homepage = "https://gitlab.xfce.org/apps/xfce4-terminal";
    license = lib.licenses.gpl2Plus;
    mainProgram = "xfce4-terminal";
    teams = [ lib.teams.xfce ];
    platforms = lib.platforms.linux;
  };
})
