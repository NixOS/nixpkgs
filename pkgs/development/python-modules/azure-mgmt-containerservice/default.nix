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
  pname = "azure-mgmt-containerservice";
  version = "5.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1dhni22n85x76709mvjmby8i8hvginzniq1dna6f5cidfcalc0vs";
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
    description = "This is the Microsoft Azure Container Service Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-containerservice;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
