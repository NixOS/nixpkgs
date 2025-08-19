{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  pytestCheckHook,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "london-tube-status";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robmarkcole";
    repo = "London-tube-status";
    tag = version;
    hash = "sha256-bdkGDVWcyJXH21qGrdJnSa4IW2kJskFTJ5ye6M6eOz4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  # Tests are currently broken
  # https://github.com/robmarkcole/London-tube-status/issues/7
  doCheck = false;

  pythonImportsCheck = [
    "london_tube_status"
  ];

  meta = {
    description = "Parse London tube data from TFL into a dictionary";
    homepage = "https://github.com/robmarkcole/London-tube-status";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
