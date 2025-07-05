{
  lib,
  appdirs,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "platformdirs";
  version = "4.3.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "platformdirs";
    repo = "platformdirs";
    tag = version;
    hash = "sha256-ePaEpsBkTomRX+RJsed8aJtefl5WCW/N9IT8ae4+ln4=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  nativeCheckInputs = [
    appdirs
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "platformdirs" ];

  meta = with lib; {
    description = "Module for determining appropriate platform-specific directories";
    homepage = "https://platformdirs.readthedocs.io/";
    changelog = "https://github.com/platformdirs/platformdirs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
