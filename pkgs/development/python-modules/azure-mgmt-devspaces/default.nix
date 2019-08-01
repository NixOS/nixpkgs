{ lib
, buildPythonPackage
, fetchPypi
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-devspaces";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "4710dd59fc219ebfa4272dbbad58bf62093b52ce22bfd32a5c0279d2149471b5";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Dev Spaces Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-devspaces;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
