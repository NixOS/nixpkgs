{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrestazure,
  azure-common,
  azure-mgmt-nspkg,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-devspaces";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0dvjsr9i87j1ggbj3dcmgifpk64xr5f5ziwf7z1fwkcx0szcid7k";
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
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
