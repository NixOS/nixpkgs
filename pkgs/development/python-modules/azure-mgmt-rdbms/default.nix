{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-rdbms";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0v91hl936wp9sl3bc31svf6kdxwa57qh6ih9rrv43dnb2000km6r";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure RDBMS Management Client Library";
    homepage = https://github.com/Azure/azure-sdk-for-python/tree/master/azure-mgmt-rdbms;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
