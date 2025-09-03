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

buildPythonPackage rec {
  pname = "napari-console";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "napari";
    repo = "napari-console";
    tag = "v${version}";
    hash = "sha256-Hvo9YMDf7CjeGn1kT7m9Y5klH0cD/SWxDQOHkYspGpQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
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
}
