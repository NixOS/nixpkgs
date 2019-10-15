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
  pname = "azure-mgmt-devtestlabs";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1397ksrd61jv7400mgn8sqngp6ahir55fyq9n5k69wk88169qm2r";
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
    description = "This is the Microsoft Azure DevTestLabs Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-devtestlabs;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
