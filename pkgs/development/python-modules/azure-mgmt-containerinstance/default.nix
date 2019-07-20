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
  pname = "azure-mgmt-containerinstance";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "87919f3e618ec0a40fd163d763113eef908e78c50d8b76bf4dd795444cb069fd";
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
    description = "This is the Microsoft Azure Container Instance Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-containerinstance;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
