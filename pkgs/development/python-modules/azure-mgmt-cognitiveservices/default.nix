{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-nspkg
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cognitiveservices";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1m7v3rfkvmdgghrpz15fm8pvmmhi40lcwfxdm2kxh7mx01r5l906";
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
