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
  version = "13.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-FXS834v5uDGiEGcQMIv9iaHxhfcW9uY3VmX7l91Tfj4=";
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
