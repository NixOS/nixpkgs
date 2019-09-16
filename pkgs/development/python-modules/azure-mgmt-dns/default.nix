{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-dns";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0zxkcczf01b64qfwj98jqdvnwqahygcyccf37rcxpdcfgpkg9kbf";
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
    description = "This is the Microsoft Azure DNS Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/dns?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
