{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-common
, azure-mgmt-core
, isodate
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-compute";
  version = "30.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-cyD7r8OSdwsD7QK2h2AYXmCUVS7ZjX/V6nchClpRPHg=";
  };

  propagatedBuildInputs = [
    azure-mgmt-common
    azure-mgmt-core
    isodate
  ];

  pythonNamespaces = [
    "azure.mgmt"
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.mgmt.compute"
  ];

  meta = with lib; {
    description = "This is the Microsoft Azure Compute Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai maxwilson ];
  };
}
