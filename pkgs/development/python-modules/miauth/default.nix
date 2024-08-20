{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  bluepy,
  cryptography,

  # checks
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "miauth";
  version = "0.9.7";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2/4nFInpdY8fb/b+sXhgT6ZPtEgBV+KHMyLnxIp6y/U=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "cryptography" ];

  dependencies = [
    bluepy
    cryptography
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "miauth" ];

  meta = with lib; {
    description = "Authenticate and interact with Xiaomi devices over BLE";
    homepage = "https://github.com/dnandha/miauth";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "miauth";
  };
}
