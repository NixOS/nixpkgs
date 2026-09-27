{
  lib,
  fetchFromGitHub,
  gobject-introspection,
  gtk4,
  libadwaita,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication {
  pname = "vapor";
  version = "0.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kalkaro";
    repo = "vapor";
    tag = "v0.1.0";
    hash = "sha256-r+FiD7QND8gZLMDnE+dggBx2g9jcuDG/heZGbC4MAJU";
  };

  build-system = [
    python3Packages.setuptools
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  dependencies = [
    python3Packages.pygobject3
  ];

  pythonImportsCheck = [
    "vapor_shortcuts"
  ];

  meta = {
    description = "Create Linux desktop launchers for Steam games with a GTK UI";
    homepage = "https://github.com/Kalkaro/vapor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kalkaro ];
    mainProgram = "vapor";
    platforms = lib.platforms.linux;
  };
}
