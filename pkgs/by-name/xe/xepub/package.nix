{
  stdenv,
  lib,
  fetchFromGitHub,
  gobject-introspection,
  meson,
  ninja,
  python3Packages,
  wrapGAppsHook3,
  glib,
  gtk3,
  python3,
  webkitgtk_4_1,
  xapp,
  xapp-symbolic-icons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xepub";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "xapp-project";
    repo = "xepub";
    tag = finalAttrs.version;
    hash = "sha256-OPCX5989u+CuDJjPOPgkhrmU8k4/HQV8Ge01q+go2Qk=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    python3Packages.wrapPython
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    python3
    webkitgtk_4_1
    xapp
  ];

  pythonPath = with python3Packages; [
    pygobject3
    python-xapp
    setproctitle
  ];

  postPatch = ''
    substituteInPlace meson.build --replace-fail "/usr/bin/python3" "python3"
  '';

  preFixup = ''
    buildPythonPath "$out ''${pythonPath[*]}"

    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

  meta = {
    description = "EPUB reader for Linux desktops";
    mainProgram = "xepub";
    homepage = "https://github.com/xapp-project/xepub";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
