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
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "b3d5b2919021bf45f0acdd34ab23dc9b0435d9d0a6b472e5008128fb8521e700";
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
