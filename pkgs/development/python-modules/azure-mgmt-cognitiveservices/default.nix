{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-nspkg
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cognitiveservices";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "d03641336f4b2ec561112655c93ee80bc28d8e8daa45a57abc36169bd19c07a0";
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
