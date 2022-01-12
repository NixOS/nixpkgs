{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cognitiveservices";
  version = "13.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "dc6116e8394d45312c7ad5a9098ce0dd2370bd92d43afd33d8b3bfab724fa498";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-core
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Cognitive Services Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
