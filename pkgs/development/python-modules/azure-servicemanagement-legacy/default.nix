{ lib
, buildPythonPackage
, fetchFromGitHub
, azure-common
, requests
}:

buildPythonPackage {
  version = "0.48.0";
  pname = "azure-servicemanagement-legacy";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    rev = "azure-mgmt-web_${version}";
    sha256 = "1ws94hnlzl5gnixx704v045b9pwqjcri9zg9k7ww84ixrbl29fyn";
  };

  preBuild = ''
    cd ./azure-servicemanagement-legacy
  '';

  propagatedBuildInputs = [
    azure-common
    requests
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Service Management Legacy Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai mwilsoninsight ];
  };
}
