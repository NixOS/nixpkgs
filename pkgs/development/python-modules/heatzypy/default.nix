{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "heatzypy";
  version = "2.5.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Cyr-ius";
    repo = "heatzypy";
    rev = "refs/tags/${version}";
    hash = "sha256-S1wIVeUTbtF5omImt38YNvZEutyCEYMGExccs0FIK44=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "heatzypy" ];

  meta = with lib; {
    description = "Module to interact with Heatzy devices";
    homepage = "https://github.com/Cyr-ius/heatzypy";
    changelog = "https://github.com/cyr-ius/heatzypy/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
