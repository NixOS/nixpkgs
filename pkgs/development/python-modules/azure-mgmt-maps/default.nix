{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  msrest,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-maps";
  version = "2.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XVaml4UuVBanYYHxjB1YT/PvExzgAPbD4gI3Hbc0dI0=";
  };

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
    msrest
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.maps" ];

  meta = {
    description = "This is the Microsoft Azure Maps Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/v${version}/sdk/maps/azure-mgmt-maps/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
