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
  version = "12.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "73054bd19866577e7e327518afc8f47e1639a11aea29a7466354b81804f4a676";
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
