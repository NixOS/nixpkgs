{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-nspkg
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cognitiveservices";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "05zbgy1d6mschqv6y14byr4nwdnv48x9skx4rbsbz1fcqqx3j2sd";
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
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-cognitiveservices;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
