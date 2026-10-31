{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrestazure,
  azure-common,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-batch";
  version = "14.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x5Jn1sPT/hShakIqtbv6vL1o7QtYtrvN+gyDRcTHhTI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    azure-common
    msrestazure
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.batch" ];

  meta = {
    description = "This is the Microsoft Azure Batch Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/batch/azure-batch";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-batch_${version}/sdk/batch/azure-batch/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
