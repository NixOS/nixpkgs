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
  pname = "azure-mgmt-redis";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "db999e104edeee3a13a8ceb1881e15196fe03a02635e0e20855eb52c1e2ecca1";
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
    description = "This is the Microsoft Azure Redis Cache Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/redis?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
