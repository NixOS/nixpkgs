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

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "xdgmenumaker";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "gapan";
    repo = "xdgmenumaker";
    rev = finalAttrs.version;
    sha256 = "rh1rRgbw8uqii4oN3XXNNKsWam1d8TY0qGceHERlG1k=";
  };

  pyproject = false;

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
    platforms = with lib.platforms; lib.filter (x: !(lib.elem x darwin)) unix;
    maintainers = [ lib.maintainers.romildo ];
  };
})
