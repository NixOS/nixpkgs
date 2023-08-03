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
  version = "30.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-pWN525DU4kwHi8h0XQ5fdzIp+e8GfNcSwQ+qmIYVp1s=";
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
