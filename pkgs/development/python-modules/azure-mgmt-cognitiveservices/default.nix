{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-nspkg
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cognitiveservices";
  version = "6.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "e0c4bbe656ababb942d708ee04f3f3305a2023e322a8b3fb1d8503aa682f59c4";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Cognitive Services Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
