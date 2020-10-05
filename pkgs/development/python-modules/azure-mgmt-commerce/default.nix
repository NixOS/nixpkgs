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
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    rev = "azure-core_${version}";
    sha256 = "1nx0mwkvwy34dpmkp3gbbjxvz12cnj2xr8lrxg1hq9clqkrl9yl5";
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
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
