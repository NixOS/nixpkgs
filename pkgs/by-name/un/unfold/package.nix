{
  stdenv,
  lib,
  fetchFromGitHub,
  _7zz,
  desktop-file-utils,
  gettext,
  gobject-introspection,
  gtk3,
  meson,
  ninja,
  python3,
  python3Packages,
  wrapGAppsHook3,
  xapp,
  xapp-symbolic-icons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unfold";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "xapp-project";
    repo = "unfold";
    tag = finalAttrs.version;
    hash = "sha256-PPJ7jbmTgHtX817YvqhumWcPeuY8eIQRvJ3Yi8Gez8s=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    meson
    ninja
    python3
    python3Packages.wrapPython
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    python3
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

    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ _7zz ]}"
      --prefix PYTHONPATH : "$program_PYTHONPATH"
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )

    wrapGApp $out/share/nemo/actions/unfold-compress-visible
  '';

  meta = {
    description = "Archive manager for Linux desktops";
    homepage = "https://github.com/xapp-project/unfold";
    license = lib.licenses.gpl3Plus;
    mainProgram = "unfold";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
