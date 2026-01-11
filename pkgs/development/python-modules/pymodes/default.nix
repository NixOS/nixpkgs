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
  version = "2.21.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "junzis";
    repo = "pyModeS";
    tag = "v${version}";
    hash = "sha256-Tla5hJ7J/3R4r4fTQMUIpY+QGvLRuNMZfWU0RsAiuk0=";
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
