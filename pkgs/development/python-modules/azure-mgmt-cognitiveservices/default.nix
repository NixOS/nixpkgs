{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-core
, msrestazure
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cognitiveservices";
  version = "13.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-GQXDIWOiKGqZqrzpNfvDR8hTU4KnpjZQKrLivcD0tsA=";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-core
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Cognitive Services Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
