{ lib
, buildPythonPackage
, fetchPypi
, msrestazure
, azure-common
, azure-mgmt-datalake-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-datalake-store";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "9376d35495661d19f8acc5604f67b0bc59493b1835bbc480f9a1952f90017a4c";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-datalake-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Data Lake Store Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
