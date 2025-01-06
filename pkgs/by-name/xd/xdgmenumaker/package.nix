{
  lib,
  fetchFromGitHub,
  atk,
  gdk-pixbuf,
  gobject-introspection,
  pango,
  python3Packages,
  txt2tags,
  wrapGAppsHook3,
  gitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "xdgmenumaker";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "gapan";
    repo = pname;
    rev = version;
    sha256 = "uSSKiceHurk+qGVnaYa4uJEuq9FQROdhcotQxPBgPIs=";
  };

  format = "other";

  strictDeps = false;

  dontWrapGApps = true;

  nativeBuildInputs = [
    gobject-introspection
    txt2tags
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    gdk-pixbuf
    pango
  ];

  pythonPath = with python3Packages; [
    pygobject3
    pyxdg
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Command line tool that generates XDG menus for several window managers";
    mainProgram = "xdgmenumaker";
    homepage = "https://github.com/gapan/xdgmenumaker";
    license = lib.licenses.gpl3Plus;
    # NOTE: exclude darwin from platforms because Travis reports hash mismatch
    platforms = lib.filter (x: !(lib.elem x lib.platforms.darwin)) lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
  };
}
