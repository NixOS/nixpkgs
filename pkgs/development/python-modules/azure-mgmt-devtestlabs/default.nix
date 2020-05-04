{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
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

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure DevTestLabs Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer mwilsoninsight ];
  };
}
