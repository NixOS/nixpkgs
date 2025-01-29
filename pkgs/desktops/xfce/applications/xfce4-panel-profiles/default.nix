{
  stdenv,
  lib,
  fetchFromGitLab,
  gettext,
  gobject-introspection,
  wrapGAppsHook3,
  glib,
  gtk3,
  libxfce4ui,
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
  version = "1.0.15";

  src = fetchFromGitLab {
    domain = "gitlab.xfce.org";
    owner = "apps";
    repo = "xfce4-panel-profiles";
    rev = "xfce4-panel-profiles-${finalAttrs.version}";
    sha256 = "sha256-UxXxj0lxJhaMv5cQoyz+glJiLwvIFfpPu27TCNDhoL0=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    libxfce4ui
    pythonEnv
  ];

  configurePhase = ''
    runHook preConfigure
    # This is just a handcrafted script and does not accept additional arguments.
    ./configure --prefix=$out
    runHook postConfigure
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "xfce4-panel-profiles-"; };

  meta = with lib; {
    homepage = "https://docs.xfce.org/apps/xfce4-panel-profiles/start";
    description = "Simple application to manage Xfce panel layouts";
    mainProgram = "xfce4-panel-profiles";
    maintainers = with maintainers; [ ] ++ teams.xfce.members;
    platforms = platforms.linux;
  };
})
