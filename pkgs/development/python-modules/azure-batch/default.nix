{ lib
, buildPythonPackage
, fetchPypi
, msrestazure
, azure-common
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "azure-batch";
  version = "14.1.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lhayyqYpx0ABItaF1VfrzQF5famImQgxj5pUdIQ5es0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    azure-common
    msrestazure
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.batch"
  ];

  meta = with lib; {
    description = "This is the Microsoft Azure Batch Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/batch/azure-batch";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-batch_${version}/sdk/batch/azure-batch/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
