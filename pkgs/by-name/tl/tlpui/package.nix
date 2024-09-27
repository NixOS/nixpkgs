{
  cairo,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  lib,
  pciutils,
  python3Packages,
  substituteAll,
  tlp,
  usbutils,
  wrapGAppsHook,
}:
python3Packages.buildPythonPackage rec {
  pname = "tlpui";
  version = "1.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "d4nj1";
    repo = "TLPUI";
    rev = "refs/tags/tlpui-${version}";
    hash = "sha256-pgzGhf2WDRNQ2z0hPapUJA5MLTKq92UlgjC+G78T/4s=";
  };

  patches = [
    (substituteAll {
      src = ./path.patch;
      inherit tlp;
    })
  ];

  # ignore test/test_tlp_settings.py asit relies on opening a gui which is non-trivial
  pytestFlagsArray = [ "--ignore=test/test_tlp_settings.py" ];
  nativeCheckInputs = [
    gobject-introspection
    python3Packages.pytestCheckHook
  ];

  build-system = [
    wrapGAppsHook
    python3Packages.poetry-core
  ];

  buildInputs = [ tlp ];

  dependencies = [
    gobject-introspection
    gtk3
    pciutils
    python3Packages.pycairo
    python3Packages.pygobject3
    python3Packages.pyyaml
    usbutils
  ];

  meta = {
    changelog = "https://github.com/d4nj1/TLPUI/releases/tag/tlpui-${version}";
    description = "A GTK user interface for TLP written in Python";
    homepage = "https://github.com/d4nj1/TLPUI";
    license = lib.licenses.gpl2Only;
    longDescription = ''
      The Python scripts in this project generate a GTK-UI to change TLP configuration files easily.
      It has the aim to protect users from setting bad configuration and to deliver a basic overview of all the valid configuration values.
    '';
    platforms = lib.platforms.linux;
    mainProgram = "tlpui";
    maintainers = with lib.maintainers; [ grimmauld ];
  };
}
