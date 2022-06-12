{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-common
, azure-mgmt-core
, pythonOlder
}:

buildPythonPackage rec {
  version = "20.0.0";
  pname = "azure-mgmt-storage";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-buR2tWIv9vWVTt7m6w2N1CezIXAihVrfHshjPKBM3uI=";
  };

  propagatedBuildInputs = [
    azure-mgmt-common
    azure-mgmt-core
  ];

  pythonNamespaces = [
    "azure.mgmt"
  ];

  pythonImportsCheck = [
    "azure.mgmt.storage"
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Storage Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer olcai maxwilson ];
  };
}
