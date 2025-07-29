{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  typing-extensions,
  msrest,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-maps";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XVaml4UuVBanYYHxjB1YT/PvExzgAPbD4gI3Hbc0dI0=";
  };

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
    msrest
  ]
  ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  pythonNamespaces = [ "azure.mgmt" ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.maps" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Maps Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/v${version}/sdk/maps/azure-mgmt-maps/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
