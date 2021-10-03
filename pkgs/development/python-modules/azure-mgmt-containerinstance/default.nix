{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerinstance";
  version = "9.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "041431c5a768ac652aac318a17f2a53b90db968494c79abbafec441d0be387ff";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.containerinstance" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Container Instance Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
