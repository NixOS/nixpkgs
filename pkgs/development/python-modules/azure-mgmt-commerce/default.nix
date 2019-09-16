{ lib
, buildPythonPackage
, fetchFromGitHub
, msrestazure
, azure-common
, azure-mgmt-nspkg
, python
, isPy3k
}:

buildPythonPackage {
  pname = "azure-mgmt-commerce";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    rev = "ee5b47525d6c1eae3b1fd5f65b0421eab62a6e6f";
    sha256 = "0xzdn7da5c3q5knh033vbsqk36vwbm75cx8vf10x0yj58krb4kn4";
  };

  preBuild = ''
    cd ./azure-mgmt-commerce
  '';

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Commerce Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-commerce;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
