{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  imageio,
  napari-plugin-engine,
  numpy,
  vispy,
}:

buildPythonPackage rec {
  pname = "napari-svg";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "napari";
    repo = "napari-svg";
    tag = "v${version}";
    hash = "sha256-m3lm+jXUuGr9WCxzo7VyZNcKadLPX2VrCC9obiSvreQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    imageio
    napari-plugin-engine
    numpy
    vispy
  ];

  # Circular dependency: napari
  doCheck = false;

  meta = {
    description = "Plugin for writing svg files from napari";
    homepage = "https://github.com/napari/napari-svg";
    changelog = "https://github.com/napari/napari-svg/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
