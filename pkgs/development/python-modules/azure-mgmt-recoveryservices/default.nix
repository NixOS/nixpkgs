{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-recoveryservices";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "azure_mgmt_recoveryservices";
    inherit version;
    hash = "sha256-oUKc/Sg6nJlQrBU0gvqcl0Fkb9INqKqcPIHnJceMXJ8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.recoveryservices" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Recovery Services Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-recoveryservices_${version}/sdk/recoveryservices/azure-mgmt-recoveryservices/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
