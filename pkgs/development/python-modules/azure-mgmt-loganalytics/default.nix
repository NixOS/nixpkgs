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
  version = "10.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "29330984d0f084dff26cea239d7b733c1a26844da85d33bf3bb53b515ce0bc23";
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
