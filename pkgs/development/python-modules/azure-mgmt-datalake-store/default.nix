{ lib
, buildPythonPackage
, fetchPypi
, msrestazure
, azure-common
, azure-mgmt-datalake-nspkg
, azure-mgmt-core
}:

buildPythonPackage rec {
  pname = "azure-mgmt-datalake-store";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-GrmVK97M+iojevPLVTuLmfQRLxvrHtr9DRHymJvLYHE=";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-core
    azure-mgmt-datalake-nspkg
  ];

  pythonNamespaces = [ "azure.mgmt.datalake" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Data Lake Store Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer maxwilson ];
  };
}
