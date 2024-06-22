{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-common,
  azure-mgmt-core,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-storage";
  version = "21.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KHyYQLAb6TGBnUA9p+1SvWL9B3sFKd1HDm28T+3ksg0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-mgmt-common
    azure-mgmt-core
    isodate
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.storage" ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Storage Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-storage_${version}/sdk/storage/azure-mgmt-storage/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      jonringer
      olcai
      maxwilson
    ];
  };
}
