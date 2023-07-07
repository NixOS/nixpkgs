{ lib
, buildPythonPackage
, fetchPypi
, msrest
, azure-common
, msrestazure
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-batch";
  version = "14.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-FlsembhvghAkxProX7NIadQHqg67DKS5b7JthZwmyTQ=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.batch"
  ];

  meta = with lib; {
    description = "This is the Microsoft Azure Batch Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
