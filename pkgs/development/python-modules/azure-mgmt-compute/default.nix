{ lib
, azure-mgmt-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-mgmt-compute";
  version = "30.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pd1tAbhn1ot2sAM+x8yKGgEpCtlp7vVyCAcAzMZhyYE=";
  };

  propagatedBuildInputs = [
    azure-mgmt-common
    azure-mgmt-core
    isodate
  ]  ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  pythonNamespaces = [
    "azure.mgmt"
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.mgmt.compute"
  ];

  meta = with lib; {
    description = "This is the Microsoft Azure Compute Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-compute_${version}/sdk/compute/azure-mgmt-compute/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson ];
  };
}
