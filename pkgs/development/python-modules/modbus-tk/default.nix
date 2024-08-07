{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  pyserial,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "modbus-tk";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "ljean";
    repo = "modbus-tk";
    rev = "refs/tags/${version}";
    hash = "sha256-zikfVMFdlOJvuKVQGEsK03i58X6BGFsGWGrGOJZGC0g=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "modbus_tk" ];

  pytestFlagsArray = [ "tests/unittest_*.py" ];

  meta = with lib; {
    description = "Module for simple Modbus interactions";
    homepage = "https://github.com/ljean/modbus-tk";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ fab ];
  };
}
