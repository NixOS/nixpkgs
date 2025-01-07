{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyzabbix";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lukecyca";
    repo = "pyzabbix";
    tag = version;
    hash = "sha256-2yCbxPUlbTrtjD9eKmkw0fKnjiwPzmjIo5vKGv4aerU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    packaging
    requests
  ];

  # Tests require a running Zabbix instance
  doCheck = false;

  pythonImportsCheck = [ "pyzabbix" ];

  meta = with lib; {
    description = "Module to interact with the Zabbix API";
    homepage = "https://github.com/lukecyca/pyzabbix";
    changelog = "https://github.com/lukecyca/pyzabbix/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ fab ];
  };
}
