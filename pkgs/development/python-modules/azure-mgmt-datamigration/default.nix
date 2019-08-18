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
  pname = "azure-mgmt-datamigration";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0bixyya9afas0sv2wji7ivfi64z4dvv8p1gjnppibi5zas1mb4zw";
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
    description = "This is the Microsoft Azure Data Migration Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-datamigration;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
