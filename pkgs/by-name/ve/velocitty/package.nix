{
  stdenv,
  lib,
  fetchFromGitHub,
  gettext,
  gobject-introspection,
  gtk4,
  libadwaita,
  meson,
  ninja,
  python3,
  python3Packages,
  vte-gtk4,
  wrapGAppsHook4,
  xapp,
  xapp-symbolic-icons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "velocitty";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "xapp-project";
    repo = "velocitty";
    tag = finalAttrs.version;
    hash = "sha256-Uj7tLBpspbnjQukXlkg0CqZOcCeCkc2/K1g6j7dSeqY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    python3
    python3Packages.wrapPython
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    python3
    vte-gtk4
    xapp
  ];

  pythonPath = with python3Packages; [
    pygobject3
    python-xapp
    setproctitle
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "/usr/bin/python3" "python3"
  '';

  preFixup = ''
    buildPythonPath "$out ''${pythonPath[*]}"
    patchPythonScript $out/bin/velocitty

    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

  meta = {
    description = "Terminal emulator for Linux desktops";
    homepage = "https://github.com/xapp-project/velocitty";
    license = lib.licenses.gpl3Plus;
    mainProgram = "velocitty";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
