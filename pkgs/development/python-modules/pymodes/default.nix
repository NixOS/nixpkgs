{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  hatchling,
  numpy,
  pytestCheckHook,
  pyzmq,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymodes";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "junzis";
    repo = "pyModeS";
    tag = "v${version}";
    hash = "sha256-oFaNWLYuF2RubAk1PT0oqmkaq/aUxITil7Q/tydMbOw=";
  };

  build-system = [
    cython
    hatchling
    setuptools
  ];

  dependencies = [
    numpy
    pyzmq
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyModeS" ];

  meta = {
    description = "Python Mode-S and ADS-B Decoder";
    homepage = "https://github.com/junzis/pyModeS";
    changelog = "https://github.com/junzis/pyModeS/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ snicket2100 ];
  };
}
