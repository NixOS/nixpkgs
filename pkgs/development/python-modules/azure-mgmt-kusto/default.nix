{ lib
, azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-kusto";
  version = "3.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PmGGtyVrYFCMnpiCq9x9uwoMboDO1ePlGAJzrMTj3ps=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.kusto"
  ];

  meta = with lib; {
    description = "Microsoft Azure Kusto Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-kusto_${version}/sdk/kusto/azure-mgmt-kusto/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
