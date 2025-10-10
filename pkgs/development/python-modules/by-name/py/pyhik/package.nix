{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyhik";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mezz64";
    repo = "pyHik";
    tag = version;
    hash = "sha256-GqBHmwzQsnVGK1M2kKV3lQ3s7tsudoxmLC7xxGH55E0=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
  ];

  # Tests are disabled due to fragile XML namespace assertions
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyhik"
  ];

  meta = {
    description = "Python API to interact with a Hikvision camera event stream and toggle motion detection";
    homepage = "https://github.com/mezz64/pyHik";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
