{
  lib,
  fetchzip,
  nmap,
  python3Packages,
  wrapGAppsHook3,
  gobject-introspection,
}:

python3Packages.buildPythonPackage rec {
  pname = "zenmap";
  version = "7.95";
  pyproject = true;

  src = fetchzip {
    url = "https://nmap.org/dist/nmap-${version}.tar.bz2";
    hash = "sha256-sikDuQb0uI+/Ryy0Evt67LHw7GzTIX8xFy/AyHxEUsg=";
  };

  sourceRoot = "${src.name}/zenmap";

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  dependencies = [
    python3Packages.pygobject3
    nmap
  ];

  meta = {
    description = "Offical nmap Security Scanner GUI";
    homepage = "http://www.nmap.org";
    changelog = "https://nmap.org/changelog.html#${version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      mymindstorm
    ];
  };
}
