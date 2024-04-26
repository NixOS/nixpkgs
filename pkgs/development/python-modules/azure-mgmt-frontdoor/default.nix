{ lib
, azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "azure-mgmt-frontdoor";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-GqrJNNcQrNffgqRywgaJ2xkwy+fOJai/RlSVkpw6NWg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # Tests are only available in mono repo
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.frontdoor" ];

  meta = with lib; {
    description = "Microsoft Azure Front Door Service Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/network/azure-mgmt-frontdoor";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-frontdoor_${version}/sdk/network/azure-mgmt-frontdoor/CHANGELOG.md"; 
    license = licenses.mit;
    maintainers = with maintainers; [ sephi ];
  };
}
