{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, isPy3k
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-advisor";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c52a4cf91d736c0ecdcb4d555e3b7713ff892343f610e7d65c63549edb98c221";
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
    description = "This is the Microsoft Azure Advisor Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
