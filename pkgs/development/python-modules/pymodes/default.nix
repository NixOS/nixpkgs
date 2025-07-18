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
  version = "2.20";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "junzis";
    repo = "pyModeS";
    tag = "v${version}";
    hash = "sha256-BC1GLQW0/UBVwx3346mZsXSREGeVS+GhqH2Rl2faUoY=";
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
