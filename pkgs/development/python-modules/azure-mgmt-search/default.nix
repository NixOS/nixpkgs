{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-search";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0ec5de861bd786bcb8691322feed6e6caa8d2f0806a50dc0ca5d640591926893";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Search Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/search?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
