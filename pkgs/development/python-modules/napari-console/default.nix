{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  ipykernel,
  ipython,
  qtconsole,
  qtpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "napari-console";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "napari";
    repo = "napari-console";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2Cbjm/SB2/ULrHkO0zS5VLgc+4T1lc/cx+mdABMpEG4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "ipykernel"
  ];
  dependencies = [
    ipykernel
    ipython
    qtconsole
    qtpy
  ];

  # Circular dependency: napari
  doCheck = false;

  meta = {
    description = "Plugin that adds a console to napari";
    homepage = "https://github.com/napari/napari-console";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
})
