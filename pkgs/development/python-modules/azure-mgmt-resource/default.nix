{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-core
, azure-mgmt-common
, msrest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-resource";
  version = "23.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-5hN6vDJE797Mcw/u0FsXVCzNr4c1pmuRQa0KN42HKSI=";
  };

  propagatedBuildInputs = [
    azure-mgmt-common
    azure-mgmt-core
    msrest
  ];

  # Module has no tests
  doCheck = false;

  pythonNamespaces = [
    "azure.mgmt"
  ];

  pythonImportsCheck = [
    "azure.mgmt.resource"
  ];

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson jonringer ];
  };
}
