{
  lib,
  python3Packages,
  fetchFromGitLab,
  gobject-introspection,
  wrapGAppsHook4,
  installShellFiles,
  libadwaita,
  meld,
}:

python3Packages.buildPythonApplication rec {
  pname = "turtle";
  version = "0.13.3";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "philippun1";
    repo = "turtle";
    tag = version;
    hash = "sha256-bfoo2xWBr4jR5EX5H8hiXl6C6HSpNJ93icDg1gwWXqE=";
  };

  postPatch = ''
    substituteInPlace ./install.py \
      --replace-fail "/usr" "$out" \
      --replace-fail "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
    installShellFiles
  ];

  buildInputs = [ libadwaita ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pygobject3
    pygit2
    secretstorage
    dbus-python
  ];

  postInstall = ''
    python ./install.py install
    installManPage data/man/*
  '';

  # Avoid wrapping two times
  dontWrapGApps = true;

  # Make sure we patch other scripts after wrapper is generated
  # to get $program_PYTHONPATH
  dontWrapPythonPrograms = true;

  postFixup = ''
    makeWrapperArgs+=(''${gappsWrapperArgs[@]})
    wrapPythonPrograms
  ''
  # Dialogs are not imported, but executed. The same does
  # nautilus-python plugins. So we need to patch them as well.
  + ''
    for dialog_scripts in $out/lib/python*/site-packages/turtlevcs/dialogs/*.py; do
      patchPythonScript $dialog_scripts
    done
    for nautilus_extensions in $out/share/nautilus-python/extensions/*.py; do
      patchPythonScript $nautilus_extensions
    done
    substituteInPlace $out/share/nautilus-python/extensions/turtle_nautilus_compare.py \
      --replace-fail 'Popen(["meld"' 'Popen(["${lib.getExe meld}"'
  '';

  meta = {
    description = "Graphical interface for version control intended to run on gnome and nautilus";
    homepage = "https://gitlab.gnome.org/philippun1/turtle";
    license = lib.licenses.gpl3Plus;
    mainProgram = "turtle_cli";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
}
