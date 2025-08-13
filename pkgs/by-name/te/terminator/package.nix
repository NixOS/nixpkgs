{
  lib,
  fetchFromGitHub,
  python3,
  keybinder3,
  intltool,
  file,
  gtk3,
  gobject-introspection,
  libnotify,
  makeBinaryWrapper,
  wrapGAppsHook3,
  vte,
  nixosTests,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "terminator";
  version = "2.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gnome-terminator";
    repo = "terminator";
    tag = "v${version}";
    hash = "sha256-RM/7jUWGDV0EdMyMeLsCrvevH+5hZSJVAKmtalxNKG8=";
  };

  nativeBuildInputs = [
    file
    intltool
    gobject-introspection
    makeBinaryWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    keybinder3
    libnotify
    python3
    vte
  ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    configobj
    dbus-python
    pygobject3
    psutil
    pycairo
  ];

  postPatch = ''
    patchShebangs tests po
  '';

  doCheck = false;

  pythonImportsCheck = [ "terminatorlib" ];

  dontWrapGApps = true;

  # HACK: 'wrapPythonPrograms' will add things to the $PATH in the wrapper. This bleeds into the
  # terminal session produced by terminator. To avoid this, we force wrapPythonPrograms to only
  # use gappsWrapperArgs by redefining wrapProgram to ignore its arguments and only apply the
  # wrapper arguments we want it to use.
  # TODO: Adjust wrapPythonPrograms to respect an argument that tells it to leave $PATH alone.
  preFixup = ''
    wrapProgram() {
      wrapProgramBinary "$1" "''${gappsWrapperArgs[@]}"
    }
  '';

  passthru.tests.test = nixosTests.terminal-emulators.terminator;

  meta = with lib; {
    description = "Terminal emulator with support for tiling and tabs";
    longDescription = ''
      The goal of this project is to produce a useful tool for arranging
      terminals. It is inspired by programs such as gnome-multi-term,
      quadkonsole, etc. in that the main focus is arranging terminals in grids
      (tabs is the most common default method, which Terminator also supports).
    '';
    changelog = "https://github.com/gnome-terminator/terminator/releases/tag/${src.tag}";
    homepage = "https://github.com/gnome-terminator/terminator";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.linux;
  };
}
