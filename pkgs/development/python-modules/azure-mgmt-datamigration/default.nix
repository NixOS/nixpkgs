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
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "49e6e68093e2d647c1c54a4027dee5b1d57f7e7c21480ae386c55cb3d5fa14bc";
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
