{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  hatchling,
  numpy,
  pytestCheckHook,
  pythonOlder,
  pyzmq,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymodes";
  version = "2.21.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Python Mode-S and ADS-B Decoder";
    homepage = "https://github.com/junzis/pyModeS";
    changelog = "https://github.com/junzis/pyModeS/releases/tag/${src.tag}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ snicket2100 ];
  };
}
