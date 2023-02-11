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
  version = "13.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-v1pTNPH0ujRm4VMt95Uw6d07lF8bgM3XIa3NJIbNLFI=";
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
