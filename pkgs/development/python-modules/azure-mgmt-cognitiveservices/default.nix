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
  version = "11.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "71414e3cd7445e44fc18f217f2d22df05c36877e1233328b2297d07ddf27e82a";
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
