{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
, azure-mgmt-core
}:

buildPythonPackage rec {
  pname = "azure-mgmt-loganalytics";
  version = "8.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "3e7a93186594c328a6f34f0e0d9209a05021228baa85aa4c1c4ffdbf8005a45f";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
    azure-mgmt-core
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Log Analytics Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
