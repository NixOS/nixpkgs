{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  msrest,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-recoveryservices";
  version = "4.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_recoveryservices";
    inherit version;
    hash = "sha256-BhQT5yVfOyVIMudXZjwuU5X7/3/u4Uy4jgUjrYpoJ8I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    msrest
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.recoveryservices" ];

  meta = {
    description = "This is the Microsoft Azure Recovery Services Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-recoveryservices_${version}/sdk/recoveryservices/azure-mgmt-recoveryservices/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
