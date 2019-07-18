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
  pname = "azure-mgmt-web";
  version = "0.41.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "5f170f25c72119ff4b4e2f39d46ce21bdb2f399f786ea24eedc15c12cfba3054";
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
    description = "This is the Microsoft Azure Web Apps Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/webapps?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
